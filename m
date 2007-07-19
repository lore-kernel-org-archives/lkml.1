Return-Path: <linux-kernel-owner+w=401wt.eu-S935728AbXGSKtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935728AbXGSKtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756220AbXGSKtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 06:49:05 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38148 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751330AbXGSKtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 06:49:04 -0400
Date: Thu, 19 Jul 2007 12:48:25 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <ak@suse.de>, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [58/58] x86: remove support for the Rise CPU
Message-ID: <20070719104825.GR3801@stusta.de>
References: <200707191154.642492000@suse.de> <20070719095545.8AB5914E06@wotan.suse.de> <20070719114529.6fcd4022@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070719114529.6fcd4022@the-village.bc.nu>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 11:45:29AM +0100, Alan Cox wrote:
> > Googling for the printk string "CPU: Rise iDragon" didn't find any dmesg
> > available online.
> > 
> > If it turns out that against all expectations there are actually users
> > reverting this patch would be easy.
> > 
> > This patch will make the kernel images smaller by a few bytes for all
> > i386 users.
> 
> Why bother. Its a tiny tiny amount of code and it requires no maintenance
> so it achieves nothing by leaving it alone and risks (slight I admit)
> breaking someones box.

- It's not only code, it also bloats everyone's kernel image.
- All it did was to fiddle with capabilities - if any computer with
  a Rise cpu running Linux actually exists it should still work.
- It's highly unlikely that we had any user of this code.

> Alan

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

