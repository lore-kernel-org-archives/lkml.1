Return-Path: <linux-kernel-owner+w=401wt.eu-S1761826AbYHAWrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761826AbYHAWrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 18:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761206AbYHAWm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 18:42:58 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:44281 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761173AbYHAWm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 18:42:56 -0400
Date: Sat, 2 Aug 2008 01:41:53 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Yudha Harimantoro T <yudha.ht@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       Avuton Olrich <avuton@gmail.com>
Subject: Re: Error on Make Modules [2.6.27-rc1]
Message-ID: <20080801224153.GL19682@cs181140183.pp.htv.fi>
References: <264b990a0807312306jc064bbbp144342de555ac4f1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <264b990a0807312306jc064bbbp144342de555ac4f1@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 01:06:33PM +0700, Yudha Harimantoro T wrote:
> Hi,
> I make with 2.6.27-rc1 with my oldconfig.
> 
> I build the kernel and there's error on modules.
> Errors :
> -----------------------------------------------------------------------
> root@system:/usr/src/linux# make
> ...................
> ...................
> CC      net/xfrm/xfrm_ipcomp.mod.ko
> LD [M] net/xfrm/xfrm_ipcomp.ko
> make[1]: Nothing to be done for `__fw_modbuild'.
> root@system:/usr/src/linux# make modules
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   Building modules, stage 2.
>   MODPOST 545 modules
> make[1]: Nothing to be done for `__fw_modbuild'.
> root@system:/usr/src/linux#
> -----------------------------------------------------------------------

Thanks for your report, everything is fine here.

@David, Sam:

This is the second report where a user thought this was an error 
message.

Kbuild does otherwise not show raw messages from GNU make.

Can you somehow hide this message?

> Best regards,
> Yudha_HT

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

