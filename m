Return-Path: <linux-kernel-owner+w=401wt.eu-S1752033AbZIXE5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbZIXE5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 00:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750871AbZIXE5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 00:57:42 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:42978 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbZIXE5l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 00:57:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=YQk6yuuW9IKucwBJw4N9LLy+h5sKslqfoTBkKGdbKuGmgXDTabLSMwxh9piP07Id0B
         uvi8e3+32abeu1Wm3208XAS4/IdI2ono7JX6VK/VdYR4C+VT4cUT9VZb8J5vQRBwKOZZ
         gDNIry0iJWDlsYWCDPbY30rxCj/rQ2dcKu69o=
MIME-Version: 1.0
In-Reply-To: <4ABAE7EB.4010208@gmail.com>
References: <4ABAE7EB.4010208@gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 24 Sep 2009 00:57:25 -0400
Message-ID: <8bd0f97a0909232157w1ae20a97x676f9ace0b1e62ee@mail.gmail.com>
Subject: Re: MTD_GPIO_ADDR compile error on current -git
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 23:30, Robert Hancock wrote:
> Just saw this compile error in current git:
>
>  CC [M]  drivers/mtd/maps/gpio-addr-flash.o
> In file included from /home/rob/linux-2.6/arch/x86/include/asm/gpio.h:20,
>                 from drivers/mtd/maps/gpio-addr-flash.c:27:
> include/asm-generic/gpio.h: In function ‘gpio_get_value_cansleep’:
> include/asm-generic/gpio.h:170: error: implicit declaration of function
> ‘gpio_get_value’
> include/asm-generic/gpio.h: In function ‘gpio_set_value_cansleep’:
> include/asm-generic/gpio.h:176: error: implicit declaration of function
> ‘gpio_set_value’
> drivers/mtd/maps/gpio-addr-flash.c: In function ‘gpio_flash_probe’:
> drivers/mtd/maps/gpio-addr-flash.c:232: error: implicit declaration of
> function ‘gpio_request’
> drivers/mtd/maps/gpio-addr-flash.c:236: error: implicit declaration of
> function ‘gpio_free’
> drivers/mtd/maps/gpio-addr-flash.c:240: error: implicit declaration of
> function ‘gpio_direction_output’
>
> I assume there's a missing dependency on GPIO or some such.. config is
> below.

i sent an updated patch to David already, but i need to send an
incremental patch
-mike
