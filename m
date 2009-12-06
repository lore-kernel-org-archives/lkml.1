Return-Path: <linux-kernel-owner+w=401wt.eu-S1756911AbZLFQfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbZLFQfJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 11:35:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755824AbZLFQfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 11:35:08 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:43887 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725AbZLFQfH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 11:35:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MlVju7bDqQH04nIY6u3Kud8CU/fLMDDEtaBtLJHrmRTuoO88vBQyNkaYZZlF1FokHz
         kc5jLZ0SMm8Idj4yP5CG73AvPCJSDh3hS0IADMuf4Ca8UexDdPKB1b7Q4lk07LA+Dpvf
         5o4Vevm9U+0NMqonHoYHGxTqVGLAdC/MW/GCA=
MIME-Version: 1.0
In-Reply-To: <4B1BDAA3.10601@gentoo.org>
References: <40a4ed590911190052w63a18bb7p516a5e759e0ffa23@mail.gmail.com>
	 <4B055609.9030306@tremplin-utc.net>
	 <4B1A53AE.9020707@tremplin-utc.net>
	 <40a4ed590912060741n4042ab1bg8188cd4eff28ca78@mail.gmail.com>
	 <4B1BDAA3.10601@gentoo.org>
Date: Sun, 6 Dec 2009 17:35:11 +0100
Message-ID: <40a4ed590912060835s61aea6aqfe6780395bfd2993@mail.gmail.com>
Subject: Re: Intel Poulsbo [psb] driver for Asus Eeepc 1101
From: Zeno Davatz <zdavatz@gmail.com>
To: Zac Medico <zmedico@gentoo.org>
Cc: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 6, 2009 at 5:24 PM, Zac Medico <zmedico@gentoo.org> wrote:
> Zeno Davatz wrote:
>> Ok, it does compile but when I insert the module I get:
>>
>> psb: Unknown symbol i2c_bit_add_bus
>
> This might solve it:
>
>  modprobe i2c_algo_bit
>
> That module comes from CONFIG_I2C_ALGOBIT=m in your kernel config.

Yes, thanks. That helped another step. I am getting the correct screen
resolution after enabling that in the kernel as well. The boot [ok]
messages of Gentoo are in a higher resolution now though. That is a
good start.

But after my X starts I get a black screen with a

-

in the top left corner. They keyboard also does not work. May be an
X.org config problem.

Also this is in my /var/log/messages

[    6.348077] [drm:psb_do_init] *ERROR* Debug is 0x00000000

Best
Zeno
