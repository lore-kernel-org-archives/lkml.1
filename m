Return-Path: <linux-kernel-owner+w=401wt.eu-S967569AbXEHAjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967569AbXEHAjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 20:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967563AbXEHAjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 20:39:15 -0400
Received: from paragon.brong.net ([66.232.154.163]:57761 "EHLO
	paragon.brong.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967491AbXEHAjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 20:39:15 -0400
X-Greylist: delayed 1837 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 May 2007 20:39:15 EDT
Date: Tue, 8 May 2007 10:08:28 +1000
From: Bron Gondwana <brong@fastmail.fm>
To: Bron Gondwana <brong@fastmail.fm>
Cc: Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.16.40
Message-ID: <20070508000828.GA20388@brong.net>
References: <20070210164113.GG12958@stusta.de> <20070212061347.GB24889@brong.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070212061347.GB24889@brong.net>
Organization: brong.net
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 05:13:47PM +1100, Bron Gondwana wrote:
> On Sat, Feb 10, 2007 at 05:41:13PM +0100, Adrian Bunk wrote:
> > New drivers since 2.6.16.39:
> > - Areca ARC11X0/ARC12X0 SATA-RAID support
> > - AMD Athlon64/FX and Opteron temperature sensor
> 
> Sorry - I think I just sent a blank reply to this!  Oops.
> 
> I was going to say - thanks.  We'll definitely be using
> this kernel since we've found that 2.6.19.2 has a
> significantly worse IO profile and either the 2.6.16.40-rc1
> kernel or 2.6.18 on otherwise identical machines with pretty
> stable loads (so we can compare back to previous weeks).
> 
> Now to figure out what's causing the extra load in the
> 2.6.19 branch!

By the way, we've just tried a 2.6.20.11 kernel on another machine
and so far (fingers crossed) we're not seeing the load issues we
had with the 2.6.19 kernel we were using.

Given that the Areca driver is the same in both, the only other funky
thing we did was a single patch to ReiserFS, but we're applying that
same patch on 2.6.20.

(my sneaking suspicion was that the delayed bitmap loading was to blame,
but it's hard to test these things short of multiple reboots, and we
don't have a testing Cyrus install that we can load that heavily)

Anyway - if this goes well for the next couple of days we'll probably
stop tracking the 2.6.16 series.  Thanks again, very much, for your work
with 2.6.16.  It was fantastic to have this resource to keep us from
having to chase more recent kernels just to get the patches we needed!

Bron.
