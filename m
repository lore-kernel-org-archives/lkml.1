Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423AbZKICOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbZKICOk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 21:14:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbZKICOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 21:14:40 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:51327 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbZKICOj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 21:14:39 -0500
MIME-Version: 1.0
In-Reply-To: <20091108091009.GB20529@n2100.arm.linux.org.uk>
References: <20091103105319.GA2492@elf.ucw.cz>
	 <20091103105737.GE20341@fluff.org.uk>
	 <20091108081314.GA16482@elf.ucw.cz>
	 <20091108091009.GB20529@n2100.arm.linux.org.uk>
Date: Sun, 8 Nov 2009 18:14:45 -0800
Message-ID: <d6200be20911081814y286d58d2yf3d9eb7e6ddffa5b@mail.gmail.com>
Subject: Re: dream: glue for mmc controller
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Pavel Machek <pavel@ucw.cz>, Ben Dooks <ben-linux@fluff.org>,
       Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 8, 2009 at 1:10 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sun, Nov 08, 2009 at 09:13:14AM +0100, Pavel Machek wrote:
>> > > +#include <asm/io.h>
>> > > +#include <asm/gpio.h>
>> > linux/gpio.h
>> > linux/io.h
>>
>> I got compile errors when trying to use linux/gpio.h:
>>
>> arch/arm/mach-msm/board-dream-gpio.c: In function
>> 'dream_gpio_configure':
>> arch/arm/mach-msm/board-dream-gpio.c:109: error: 'GPIOF_OUTPUT_LOW'
>> undeclared (first use in this function)
>
> This means it's abusing the gpio header files - which are intended for
> the generic GPIO support, but are being used for this platforms private
> non-generic GPIO based stuff.
>

It also means that CONFIG_GENERIC_GPIO is not set, so linux/gpio.h
stubbed out all the gpio functions.

-- 
Arve Hjønnevåg
