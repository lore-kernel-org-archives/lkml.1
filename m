Return-Path: <linux-kernel-owner+w=401wt.eu-S1752658AbXCRQK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbXCRQK6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 12:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbXCRQK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 12:10:58 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:34221 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752658AbXCRQK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 12:10:57 -0400
Date: Sun, 18 Mar 2007 17:11:00 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Thibaud Hulin <hulin.thibaud@wanadoo.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: I can't compile with success because ueagle-atm.ko undefined
Message-ID: <20070318161100.GQ752@stusta.de>
References: <45FC74C7.3010406@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <45FC74C7.3010406@wanadoo.fr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2007 at 12:07:51AM +0100, Thibaud Hulin wrote:
> Hi,
> I can't compile with success my kernel, i've got this error message :
> 
>   Building modules, stage 2.
>   MODPOST 1750 modules
> WARNING: Can't handle masks in drivers/ide/pci/atiixp:FFFF05
> WARNING: "try_to_freeze" [drivers/usb/atm/ueagle-atm.ko] undefined!
> make[2]: *** [__modpost] Erreur 1
> make[1]: *** [modules] Erreur 2

You didn't mention the kernel version, but this is a bug in kernels 
2.6.20 and 2.6.20.1 fixed in kernel 2.6.20.2 (and 2.6.20.3).

> When I uncheck this module, the compiled kernel works, but there are 
> many problems and the kernel fails after minutes.
>...

That sounds like an unrelated problem that should be reported.

> Thanks for help,
> Thibaud.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

