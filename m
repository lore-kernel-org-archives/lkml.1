Return-Path: <linux-kernel-owner+w=401wt.eu-S1765380AbYEGThX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765380AbYEGThX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 15:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755861AbYEGThJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 15:37:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56169 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbYEGThG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 15:37:06 -0400
Date: Wed, 7 May 2008 16:36:28 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch] sound/video: fix sound/i2c/other/tea575x-tuner.c build
 bug
Message-ID: <20080507163628.794f3f96@gaivota>
In-Reply-To: <s5hk5ifwrnz.wl%tiwai@suse.de>
References: <20080429204643.GA22078@elte.hu>
	<s5hk5ifwrnz.wl%tiwai@suse.de>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 12:41:52 +0200
Takashi Iwai <tiwai@suse.de> wrote:

Takashi,

I'm assuming that you're handing this issue, right?

> > Index: linux/sound/pci/Kconfig
> > ===================================================================
> > --- linux.orig/sound/pci/Kconfig
> > +++ linux/sound/pci/Kconfig
> > @@ -529,6 +529,7 @@ config SND_FM801_TEA575X
> >  	depends on SND_FM801_TEA575X_BOOL
> >  	default SND_FM801
> >  	select VIDEO_V4L1
> > +	select VIDEO_V4L1_COMPAT
> >  	select VIDEO_DEV

Hmm... VIDEO_V4L1 where renamed as VIDEO_ALLOW_V4L1. Probably, this is what's
broken for SND_FM801_TEA575X.

Cheers,
Mauro
