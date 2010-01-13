Return-Path: <linux-kernel-owner+w=401wt.eu-S1755799Ab0AMKiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab0AMKiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:38:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755734Ab0AMKiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:38:11 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:45472 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421Ab0AMKiI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:38:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZBHbcwpl0xro6AjZmieRWfEA54+9H0x846GYmrklc59BN1fecPSmi37i7mlFlq4HWZ
         3KFD7nTWMMvxOavELoPEUE12hOOUsQVsxQmCQ6CmpNznXa1yUTQme/7AhMgj+EsRqUDT
         HPyQWa5RlsQngHpGuuGMY+xlg+7aoi1YwAK5s=
MIME-Version: 1.0
In-Reply-To: <20100113112515.3c73ceee@hyperion.delvare>
References: <1263332203-5542-1-git-send-email-cascardo@holoscopio.com>
	 <20100113112515.3c73ceee@hyperion.delvare>
Date: Wed, 13 Jan 2010 14:38:04 +0400
Message-ID: <1a297b361001130238o524674a4j1c197fd694637d95@mail.gmail.com>
Subject: Re: [PATCH] i2c: do not use device name after device_unregister
From: Manu Abraham <abraham.manu@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       linux-i2c@vger.kernel.org,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 2:25 PM, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Thadeu,
>
> On Tue, 12 Jan 2010 19:36:43 -0200, Thadeu Lima de Souza Cascardo wrote:
>> dev_dbg outputs dev_name, which is released with device_unregister. This bug
>> resulted in output like this:
>>
>> [ 7860.470713] i2c Xy2�0: adapter [SMBus I801 adapter at 1880] unregistered
>>
>> The right output would be:
>> [   60.639233] i2c i2c-0: adapter [SMBus I801 adapter at 1880] unregistered
>
> I can't reproduce this bug. Do you have a specific memory poisoning
> option enabled by any chance? And which kernel version are you running
> exactly?


Same thing happens here with 2.6.30.5:

[11984.257365] i2c-adapter kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk�[�t��
 : adapter [SAA716x I2C Core 0] unregistered

Regards,
Manu
