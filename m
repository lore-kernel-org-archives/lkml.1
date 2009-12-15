Return-Path: <linux-kernel-owner+w=401wt.eu-S1753236AbZLOGsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbZLOGsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 01:48:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbZLOGsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 01:48:05 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:44337 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbZLOGsC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 01:48:02 -0500
MIME-Version: 1.0
In-Reply-To: <20091214064545.GK5114@elf.ucw.cz>
References: <20091208102842.GH12264@elf.ucw.cz>
	 <20091208214658.GC4164@elf.ucw.cz> <4B1ECEEE.3000209@bluewatersys.com>
	 <4B203575.6050407@bluewatersys.com>
	 <20091210172458.GJ19454@elf.ucw.cz>
	 <4B2150B7.3040207@bluewatersys.com>
	 <BD79186B4FD85F4B8E60E381CAEE190901FB0F92@mi8nycmail19.Mi8.com>
	 <20091211221015.GB24456@elf.ucw.cz>
	 <BD79186B4FD85F4B8E60E381CAEE190901FB10EA@mi8nycmail19.Mi8.com>
	 <20091214064545.GK5114@elf.ucw.cz>
Date: Mon, 14 Dec 2009 22:48:01 -0800
Message-ID: <d6200be20912142248n67cf020fw2bda313febe90fb9@mail.gmail.com>
Subject: Re: GPIO support for HTC Dream
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
       Ryan Mallon <ryan@bluewatersys.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>,
       Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 13, 2009 at 10:45 PM, Pavel Machek <pavel@ucw.cz> wrote:
>> > +int __init dream_init_gpio(void)
>> > +{
>> > +        int i;
>> > +
>> > +        for (i = 0; i < ARRAY_SIZE(msm_gpio_banks); i++)
>> > +                gpiochip_add(&msm_gpio_banks[i].chip);
>> > +
>> > +   return 0;
>> > +}
>>
>> Your original patch was initially writing the shadow values to the registers.
>> Do you still need to do that?
>
> It seems to boot this way :-). If writing the shadow values is not
> needed, lets try getting away without it...

I may boot this way, but unless you know that the bootloader
initialized all the registers to the same value, some outputs will be
in the wrong state until someone writes to a gpio in the same bank.

-- 
Arve Hjønnevåg
