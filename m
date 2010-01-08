Return-Path: <linux-kernel-owner+w=401wt.eu-S1753108Ab0AHLIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab0AHLIt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 06:08:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815Ab0AHLIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 06:08:49 -0500
Received: from mga06.intel.com ([134.134.136.21]:56632 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750709Ab0AHLIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 06:08:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,241,1262592000"; 
   d="scan'208";a="482409745"
Date: Fri, 8 Jan 2010 12:10:23 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Convert the AB3100 driver to use threaded IRH
Message-ID: <20100108111021.GC3734@sortiz.org>
References: <1262905725-4178-1-git-send-email-linus.walleij@stericsson.com>
 <20100108093303.GA3734@sortiz.org>
 <20100108094627.GA17598@sortiz.org>
 <63386a3d1001080209q51cf62f8tfbe7c2062e1657f3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63386a3d1001080209q51cf62f8tfbe7c2062e1657f3@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 11:09:31AM +0100, Linus Walleij wrote:
> 2010/1/8 Samuel Ortiz <sameo@linux.intel.com>:
> 
> > Linus, I fogot to mention that I removed IRQF_SAMPLE_RANDOM from your
> > request_threaded_irq() arguments, as it is scheduled for removal. See
> > Documentation/feature-removal-schedule.txt.
> > Please let me know if that's a problem for you.
> 
> I got the warning from checkpatch as well, and since this is an
> interrupt source which is truly random and we really *want* to sample
> for some IRQ randomness I do want that functionality in there.
> 
> However the fucntions to be used instead,
> rand_initialize_irq() + add_interrupt_randomness() aren't used
> anywhere else in the kernel than in the interrupt driver core.
> 
> But I don't mind being first ... if you upload your git tree to
> git.kernel.org I'll make a patch to reenable this the right way.
> (Or I can rewrite the previous patch, your choice.)
I'll push your patch without IRQF_SAMPLE_RANDOM to my for-next branch. Feel
free to send me a patch against it.

Cheers,
Samuel.

 
> Linus

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
