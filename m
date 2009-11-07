Return-Path: <linux-kernel-owner+w=401wt.eu-S1751877AbZKGMnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbZKGMnt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 07:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbZKGMnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 07:43:46 -0500
Received: from mail-iw0-f180.google.com ([209.85.223.180]:44218 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbZKGMnp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 07:43:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fe7DGOCHmNiV1GRaTORNaU9Hi7nfwrJN4WG1jJ4bNZ2XAdunQOsT0elOSkveFHtmRl
         UKUan1CEUIVt5K0CN5BOkbtipGyOBTs4eAXWAawd9tK+bWAN8UzUl5mznoYeA3iCryUp
         khBX4MwOYnfaB9qwHoE4/zz9YrpaC7+ZNAydM=
MIME-Version: 1.0
In-Reply-To: <20091105192725.GE1392@ucw.cz>
References: <90b950fc0911020050q3bc3fae8j954ec6ed73d79b5@mail.gmail.com>
	 <20091105192725.GE1392@ucw.cz>
Date: Sat, 7 Nov 2009 21:43:50 +0900
Message-ID: <90b950fc0911070443s57d2ec5ehcb5c9cf9edcf8d8c@mail.gmail.com>
Subject: Re: [patch] added brightness feature to lcd class.
From: InKi Dae <daeinki@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Kyungmin Park <kmpark@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your comments.

using backlight is good way in case of TFT-LCD Panel.
because TFT-LCD Panel needs backlight device to light up.

but AMOLED LCD Panel doesn't need backlight device because lighting up itself.
if you try to control brightness of AMOLED LCD Panel and using backlight class
then you should write fake backlight driver that it has no real device
for controlling
and would control brightness through that driver.

with this reason, I think that it's better to control brightness
through lcd class in case of AMOLED LCD panel.
If lcd class has birghtness feature then AMOLED LCD Panel driver would
become more simple and effective.

I think it is more generic way that only real device should have
device driver so I proposed this.

Thank you.

Best Regards,
InKi Dae.

2009/11/6 Pavel Machek <pavel@ucw.cz>:
> On Mon 2009-11-02 17:50:02, InKi Dae wrote:
>> This patch adds brightness feature to lcd class.
>> (kernel/driver/video/backlight/lcd.c)
>>
>> In the past, most of the lcd panels for embedded system was TFT-LCD
>> Panel needing backlight device.
>> But now AMOLED LCD Panel appeared so we should consider brightness
>> control for AMOLED Panel.
>>
>> For the time being, I used backlight fake driver for brightness
>> control of AMOLED LCD Panel.
>> But this way is not good, so I propose to add brightness feature to lcd class.
>>
>
> Why is it 'not good'? Using backlight driver seems like way to go to
> me.
>
>                                                                        Pavel
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>
