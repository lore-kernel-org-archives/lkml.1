Return-Path: <linux-kernel-owner+w=401wt.eu-S1759359AbZJNTjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359AbZJNTjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759161AbZJNTjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:39:06 -0400
Received: from www.tglx.de ([62.245.132.106]:45805 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758715AbZJNTjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:39:04 -0400
Date: Wed, 14 Oct 2009 21:38:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arndbergmann@googlemail.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:bkl/drivers] drivers: Remove BKL from misc_open
In-Reply-To: <200910141912.40190.arnd@arndb.de>
Message-ID: <alpine.LFD.2.00.0910142136010.9428@localhost.localdomain>
References: <20091010153349.237173041@linutronix.de> <alpine.LFD.2.00.0910141816020.9428@localhost.localdomain> <200910141854.49418.arnd@arndb.de> <200910141912.40190.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Oct 2009, Arnd Bergmann wrote:
> > drivers/gpu/vga/vgaarb.c
> > drivers/hwmon/lis3lv02d.c
> > fs/cachefiles/daemon.c
> > fs/fuse/cuse.c
> > net/rfkill/core.c

Sigh, will have a look. 

> > drivers/staging/android/binder.c
> > drivers/staging/dream/qdsp5/audio_aac.c
> > drivers/staging/dream/qdsp5/audio_evrc.c
> > drivers/staging/dream/qdsp5/audio_in.c
> > drivers/staging/dream/qdsp5/audio_out.c
> > drivers/staging/dream/qdsp5/snd.c
> > drivers/staging/dream/smd/smd_qmi.c
> > drivers/staging/panel/panel.c

More sigh.
 
> These are new drivers that were merged after the pushdown
> and should be looked at, though I don't expect that any of
> them to need it because none of them use the locked ioctl
> method or any other form of BKL.

Right I looked at quite a bunch of them.
 
Thanks,

	tglx
