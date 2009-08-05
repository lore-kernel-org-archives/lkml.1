Return-Path: <linux-kernel-owner+w=401wt.eu-S933567AbZHELhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933567AbZHELhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 07:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933097AbZHELhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 07:37:07 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:27679 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932900AbZHELhF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 07:37:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jwaGQ4/D/xRGhuEwJbHjV1egJgGmd843NUhYfsl4sO7n2+m/FqOLuD+psXMF8J87N7
         eaJP+ObKOureYZta0mcT3NZkOgM1GrbPvpWt3A+iXJbaNnGD5ry5X4HtcsNKO3FOADkD
         XQVnii4/XF5Sy0bYVrp7TLazgSg4J1e+99a0I=
MIME-Version: 1.0
In-Reply-To: <20090804201032.GB30892@infomag.iguana.be>
References: <4A69CE00.10401@gmail.com>
	 <20090804201032.GB30892@infomag.iguana.be>
Date: Wed, 5 Aug 2009 19:37:04 +0800
Message-ID: <e68bb3470908050437ma86dddem7621bb7d0da82607@mail.gmail.com>
Subject: Re: [PATCH] Add watchdog driver for w90p910
From: Wan ZongShun <mcuos.com@gmail.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Wim,


>> +static irqreturn_t w90p910_wdt_irq(int irq, void *dev_id)
>> +{
>> +     w90p910_wdt_keepalive();
>> +     return IRQ_HANDLED;
>> +}
>
> How does the interrupt work? what does the watchdog do when it times out?
> (Is there a datasheet available somewhere?)
>

Here is the w90p910 datasheet link, now the ic was renames nuc910.
Maybe you can give me a good idea,
hmm, regarding the timer as your mentioned (at91sam9_wdt.c), I am
studying it and will resubmit a updated patch to you. thanks a lot for
your help !

http://www.nuvoton-usa.com/hq/enu/ProductAndSales/ProductLines/ConsumerElectronicsIC/ARMMicrocontroller/ARMMicrocontroller/NUC910A.htm


>
>> +static int w90p910_wdt_settimeout(int new_time_level)
>> +{
>> +     unsigned int val;
>> +
>> +     if ((new_time_level < 0) || (new_time_level > WDT_MAX_TIME_LEVEL))
>
