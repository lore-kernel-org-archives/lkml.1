Return-Path: <linux-kernel-owner+w=401wt.eu-S2992713AbXDYL2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992713AbXDYL2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 07:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992715AbXDYL2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 07:28:51 -0400
Received: from twin.jikos.cz ([213.151.79.26]:46506 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992704AbXDYL2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 07:28:50 -0400
Date: Wed, 25 Apr 2007 13:28:05 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Helge Hafting <helge.hafting@aitel.hist.no>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.21-rc6-mm1 USB related boot hang
In-Reply-To: <462F2558.5010909@aitel.hist.no>
Message-ID: <Pine.LNX.4.64.0704251324540.20657@twin.jikos.cz>
References: <20070408143559.f5014629.akpm@linux-foundation.org>
 <20070411194227.GA31286@aitel.hist.no> <20070411134346.d10765da.akpm@linux-foundation.org>
 <20070411230700.GA4023@aitel.hist.no> <Pine.LNX.4.64.0704122023510.12991@twin.jikos.cz>
 <20070412202519.GB14705@aitel.hist.no> <Pine.LNX.4.64.0704130107170.12991@twin.jikos.cz>
 <462F2558.5010909@aitel.hist.no>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007, Helge Hafting wrote:

> > Anyway, based on information you have provided in your later messages, 
> > it seems that it is probably not necessairly related neither to USB 
> > nor HID, as you are getting hangs at different stages of boot, 
> > depending on your local configuration/kernel version used. Is vanilla 
> > 2.6.21-rc6 ok? If so, would you have time to bisect the offending 
> > patch?
> I don't know about 2.6.21-rc6, but 2.6.21-rc7 (from fresh sources) is 
> good.  It boots up without hanging, and my USB devices works too. Should 
> I test rc7-mm1 then?

That would also be useful.

But really identifying offending patch using bisection would help most. 
And it should be pretty easy and not too much time consuming for you, as 
the bug triggers immediately upon boot in your case.

In case you are not convenient with "bisecting by hand" Andrew's quilt 
patchset, don't forget that it is also possible to obtain -mm tree through 
git, which provides very convenient means for bisecting. This is what I 
usually do.

-- 
Jiri Kosina
