Return-Path: <linux-kernel-owner+w=401wt.eu-S1759410AbYG1SIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410AbYG1SIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 14:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbYG1SIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 14:08:05 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:41843 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754020AbYG1SIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 14:08:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=4DokyOtKtIW+XknWkQOoFudjez+zHha42JixjIplmueJNw34ypLwZEpiQlBEFXFT3ztooEo/hMHUDMhHX63kui1E4ldl43fld/eLUJlrVsiPROd3GZL8Uft2Lr6Ptih8c11O5xgIM/tYq2nsNKe5uhFCDN4pol+eWOckxAnRy2s=  ;
X-YMail-OSG: oqiKyhMVM1mWi7CKgtTBzqyu8VKDJjGqT5hH7Pb3b697b2lYpygFTh.jb2bQkLzLPHUzg9Q3mEE8KJaNcctTJgRv9f2SxS8Wz8.rCjGg_w--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] asm-generic/gpio.h must #include <linux/errno.h>
Date: Mon, 28 Jul 2008 11:07:55 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20080728152716.GC30612@cs181140183.pp.htv.fi>
In-Reply-To: <20080728152716.GC30612@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200807281107.55712.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 July 2008, Adrian Bunk wrote:
>   CC      arch/mips/kernel/gpio_txx9.o
> In file included from 
> /home/bunk/linux/kernel-2.6/git/linux-2.6/include/asm-mips/mach-generic/gpio.h:19,
>                  from include2/asm/gpio.h:4,
>                  from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/gpio.h:7,
>                  from /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/mips/kernel/gpio_txx9.c:13:
> /home/bunk/linux/kernel-2.6/git/linux-2.6/include/asm-generic/gpio.h: In function 'gpio_export':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/include/asm-generic/gpio.h:163: error: 'ENOSYS' undeclared (first use in this function)
> /home/bunk/linux/kernel-2.6/git/linux-2.6/include/asm-generic/gpio.h:163: error: (Each undeclared identifier is reported only once
> /home/bunk/linux/kernel-2.6/git/linux-2.6/include/asm-generic/gpio.h:163: error: for each function it appears in.)
> make[2]: *** [arch/mips/kernel/gpio_txx9.o] Error 1

A similar patch from Atsushi Nemoto landed in my inbox 11 minutes
before yours ... so his gets the ack!  ;)


