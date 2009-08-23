Return-Path: <linux-kernel-owner+w=401wt.eu-S1752058AbZHWEpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058AbZHWEpl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 00:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbZHWEpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 00:45:40 -0400
Received: from mail-vw0-f172.google.com ([209.85.212.172]:62478 "EHLO
	mail-vw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbZHWEpj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 00:45:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PZdCevktxAJEYHGEUKOtLuE3APquzTGpTUky4lwxVjZuaWoq9qrqohKBKX2oxt4lcC
         ml4GtNpjN0X/rn6TkH9HkielTcGF0xLc66wxFeGupw29UrzjE1+RW6DqsuBnwntkw9yV
         HYm2fm20khlIeFtfR7ZBUgsRi0VidgY6sm5lY=
MIME-Version: 1.0
In-Reply-To: <4A902904.2090008@gmail.com>
References: <5d5443650908221004y5b893382m368dc18a38636c1b@mail.gmail.com>
	 <4A902904.2090008@gmail.com>
Date: Sun, 23 Aug 2009 13:45:40 +0900
X-Google-Sender-Auth: 11ebfbee2f4265bf
Message-ID: <9c9fda240908222145j1938baa3v3ecf8c5899ce3850@mail.gmail.com>
Subject: Re: haptics devices linux driver support
From: Kyungmin Park <kmpark@infradead.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Trilok Soni <soni.trilok@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There's three types as I know,

1) just GPIO enable motor
2) GPIO & PWM motor.
3) I2C based GPIO & PWM motor.

Frankly we made a motor framework at kernel. but I 'm not sure motor
is right naming or not.
I think we need new framework. since it's not input device.

Thank you,
Kyungmin Park


On Sun, Aug 23, 2009 at 2:21 AM, Jiri Slaby<jirislaby@gmail.com> wrote:
> On 08/22/2009 07:04 PM, Trilok Soni wrote:
>> Does anyone know example Linux drivers for haptics devices?
>
> Yup, drivers/misc/phantom.c for Sensable Phantom (the old one over PCI).
> The rest needed (esp. floating point computation) is done in userspace.
>
> Then, all force-feedack drivers under drivers/input and drivers/hid.
>
> What exactly do you want to know?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
