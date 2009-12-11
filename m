Return-Path: <linux-kernel-owner+w=401wt.eu-S1758396AbZLKXMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758396AbZLKXMb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761549AbZLKXM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:12:29 -0500
Received: from exprod6og112.obsmtp.com ([64.18.1.29]:57217 "EHLO
	exprod6og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761384AbZLKXM2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:12:28 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: GPIO support for HTC Dream
Date: Fri, 11 Dec 2009 18:12:35 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901FB10EB@mi8nycmail19.Mi8.com>
In-Reply-To: <d6200be20912111440k427c5013j2b17191bcbae2d52@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: GPIO support for HTC Dream
Thread-Index: Acp6svjcYJvAE8eDQuaaXYbMbTd/FgAA7AKg
References: <20091208102842.GH12264@elf.ucw.cz> <4B1EB57D.6070408@bluewatersys.com> <20091208214658.GC4164@elf.ucw.cz> <4B1ECEEE.3000209@bluewatersys.com> <4B203575.6050407@bluewatersys.com> <20091210172458.GJ19454@elf.ucw.cz> <4B2150B7.3040207@bluewatersys.com> <BD79186B4FD85F4B8E60E381CAEE190901FB0F92@mi8nycmail19.Mi8.com> <20091211221015.GB24456@elf.ucw.cz> <d6200be20912111440k427c5013j2b17191bcbae2d52@mail.gmail.com>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: =?iso-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       "Pavel Machek" <pavel@ucw.cz>
Cc: "Ryan Mallon" <ryan@bluewatersys.com>,
       "Daniel Walker" <dwalker@codeaurora.org>,
       "Iliyan Malchev" <malchev@google.com>,
       "Brian Swetland" <swetland@google.com>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>
X-OriginalArrivalTime: 11 Dec 2009 23:12:34.0382 (UTC) FILETIME=[6C0C26E0:01CA7AB7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 11, 2009 3:41 PM, Arve Hjønnevåg wrote:

<snip>

>> Now, it will still need some cleanups -- I'm not sure if gpios are
>> dream-specific or generic for whole msm.... I kind of assume they
>> should be generic for msm. Google people, can you help?
>
> I'm not exactly sure what you are asking. Gpios in general are not
> dream specific, the code in board-dream-gpio.c is. Some gpios (e.g.
> DREAM_4_BALL_UP_0) are used for a dream specific function, but point
> to a gpio that is generic to the msm architecture.

<snip>

>> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>> index 1c4119c..8bb8546 100644
>> --- a/arch/arm/Kconfig
>> +++ b/arch/arm/Kconfig
>> @@ -565,6 +565,8 @@ config ARCH_MSM
>>        select CPU_V6
>>        select GENERIC_TIME
>>        select GENERIC_CLOCKEVENTS
>> +       select GENERIC_GPIO
>> +       select ARCH_REQUIRE_GPIOLIB
>
> Please do not do this in a board specific change. You have not changed
> the msm generic gpio support to use gpiolib.

Where is the msm tree located?  mach-msm in mainline doesn't appear to
have _any_ gpio support.  Is Pavel's implementation generic enough to
work with any msm based board?

Regards,
Hartley
