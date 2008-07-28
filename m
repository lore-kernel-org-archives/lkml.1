Return-Path: <linux-kernel-owner+w=401wt.eu-S1760242AbYG1Vtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760242AbYG1Vtg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbYG1VtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:49:25 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:44138 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759303AbYG1VtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:49:25 -0400
Date: Tue, 29 Jul 2008 00:48:41 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: bad CONFIG variable references from Makefiles
Message-ID: <20080728214841.GG7713@cs181140183.pp.htv.fi>
References: <alpine.LFD.1.10.0807281607400.28285@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807281607400.28285@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 04:09:28PM -0400, Robert P. J. Day wrote:
> 
>   a complete list of all references to non-existent CONFIG variables
> exclusively from Makefiles in the tree.  since the list is so short,
> i'm not bothering to break it up by subsystem or arch.  enjoy.
>...
> ===== RADIO_MIROPCM20 =====
> ./drivers/media/radio/Makefile:obj-$(CONFIG_RADIO_MIROPCM20) += miropcm20.o
> ===== RADIO_MIROPCM20_RDS =====
> ./drivers/media/radio/Makefile:obj-$(CONFIG_RADIO_MIROPCM20_RDS) += miropcm20-rds.o
>...

Mauro, 1.5 years ago you said you wanted this code to stay for having it 
perhaps ported to ALSA.

Do you still want it to stay or could it be removed now (if anyone 
suddenly feels the desire to work on it the code is still in older 
kernels)?

> rday

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

