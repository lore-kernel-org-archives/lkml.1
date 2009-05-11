Return-Path: <linux-kernel-owner+w=401wt.eu-S1758491AbZEKNa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758491AbZEKNa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 09:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbZEKNaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 09:30:09 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:2148 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbZEKNaH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 09:30:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Jrfq8CPQRc5wAZL+c4L8yyyzFU2g1EXjllAmGdXk1FdNZCe/jLA95QsKKAxD1kHwcm
         uCBNzU1u9xkYqqEvmXqdG8MSFJQZHa8beEekXFPo/npAcBbU3LlrNaqGaJBfZwInGqOK
         2GptADLZmAw7lNufVCHmYRrbAau14imAZPuQM=
MIME-Version: 1.0
In-Reply-To: <20090511112801.GA20283@sirena.org.uk>
References: <Pine.LNX.4.64.0905060829580.24668@venus.araneidae.co.uk> 
	<20090506102202.73d6045d@hyperion.delvare> <Pine.LNX.4.64.0905081102060.14384@venus.araneidae.co.uk> 
	<fd6b62c10905110311w6350828tf90d9c699b73fe30@mail.gmail.com> 
	<Pine.LNX.4.64.0905111126020.20970@venus.araneidae.co.uk> 
	<20090511112801.GA20283@sirena.org.uk>
From: =?GB2312?B?0sHU8w==?= <wxc200@gmail.com>
Date: Mon, 11 May 2009 21:29:53 +0800
Message-ID: <fd6b62c10905110629w6c9a641fr878351fb9217a32e@mail.gmail.com>
Subject: Re: [PATCH 2.6.29.2] PXA I2C: Define log level for i2c PXA error 
	report
To: Mark Brown <broonie@sirena.org.uk>
Cc: Michael Abbott <michael@araneidae.co.uk>, linux-i2c@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/11 Mark Brown <broonie@sirena.org.uk>:
> On Mon, May 11, 2009 at 11:31:51AM +0100, Michael Abbott wrote:
>
>> static struct i2c_pxa_platform_data xcep_i2c_platform_data  = {
>>         .class = I2C_CLASS_HWMON
>> };
>
>> ...
>>         pxa_set_i2c_info(&xcep_i2c_platform_data);
>
>> This is called in the .init_machine method, and the target system is a
>> PXA255.
>
>> However, after the error messages on startup, all the sensors seem to be
>> detected and seem to be operating normally.
>
> These errors occur when attempting to talk to non-existant devices which
> is almost certainly going to happen with the class based device probing
> since the kernel will probe for each device at each possible address on
> each I2C bus.
>
that happen when the device driver registered but the hardware doesnot
exist.i once met this
when my camera driver could not find the hardware camera.

thanks
--wxc200
