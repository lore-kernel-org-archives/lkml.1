Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbXHVDfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbXHVDfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 23:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbXHVDfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 23:35:30 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42033 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754454AbXHVDf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 23:35:29 -0400
Date: Tue, 21 Aug 2007 20:34:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Stuart_Hayes@Dell.com" <Stuart_Hayes@dell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Exner <dex@dragonslave.de>
Subject: Re: [linux-usb-devel] [4/4] 2.6.23-rc3: known regressions
In-Reply-To: <alpine.LFD.0.999.0708210016420.30176@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0708212026200.30176@woody.linux-foundation.org>
References: <46C098FD.1030601@googlemail.com>
 <alpine.LFD.0.999.0708202201580.30176@woody.linux-foundation.org>
 <alpine.LFD.0.999.0708202255130.30176@woody.linux-foundation.org>
 <200708202334.38261.david-b@pacbell.net> <alpine.LFD.0.999.0708202348460.30176@woody.linux-foundation.org>
 <alpine.LFD.0.999.0708210016420.30176@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 21 Aug 2007, Linus Torvalds wrote:
> 
> Side note: after reverting 196705c9bb I can't get the mouse to skip any 
> more on that mac mini. But since the bad behaviour wasn't 100% reliable to 
> begin with, that's not really a guarantee of anything. Two out of three 
> kids are off on camp this week, so that machine probably won't be getting 
> a lot of testing ;/

Well, my one remaining child said today that "I got so much time on 
webkinz today - yesterday the mouse locked up after five minutes".

Apparently it hadn't had the mouse lock up at all today.

So I really do believe that that 196705c9bb commit caused problems on 
intel-only USB machines too ("ondemand" cpufreq governor, switching 
between 1.0-1.66 Ghz using acpi-cpufreq: totally bog-standard in all 
respects, in other words).

		Linus
