Return-Path: <linux-kernel-owner+w=401wt.eu-S1759350AbYCZMeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350AbYCZMeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 08:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755572AbYCZMeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 08:34:04 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41530 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567AbYCZMeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 08:34:02 -0400
Date: Wed, 26 Mar 2008 11:21:51 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, kernel list <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: iommu breaks usb after resume
Message-ID: <20080326102151.GB18965@elf.ucw.cz>
References: <20080320111429.GA14764@elf.ucw.cz> <20080321135418.GB2346@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080321135418.GB2346@one.firstfloor.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > On 64-bit machine with 4GB ram (8core from amd), iommu breaks USB
> > after swsusp. iommu=soft fixes that issue.
> > 
> > I guess iommu handling in arch/x86/kernel/ should have some
> > suspend/resume support, as it manipulates hardware registers...?
> 
> AGP suspend/resume should already handle restoring of the aperture
> and the IOMMU code uses the same.  It has not other state. It might not work 
> when the AGP driver is not compiled in/loaded though (I suspect
> that is what happened to you) One simple fix would be to just enforce
> that in Kconfig when suspend/resume is enabled.

I had:

CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_SIS is not set
CONFIG_AGP_VIA=y
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set

...do I need to enable something more?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
