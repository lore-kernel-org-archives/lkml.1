Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550AbZESR0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbZESR0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 13:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755645AbZESR0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 13:26:21 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:32830 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458AbZESR0T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 13:26:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=e2p0/iyxqZmAgcogy8cithWeBW1FLoTyK/5k4s1Jmvpl2mTZ2SE8G356MEcqr6aaNL
         J3CrE+bcxDxxXf7E6TYKK70TXitVJuY7HLeFz8FowFC2+c9U3CusA/kqSlaNF7OAhtZ6
         X6PXiKjcAMFnXse8fssvPYtjiIHrowp+bo58k=
MIME-Version: 1.0
In-Reply-To: <63386a3d0905190923t36d301c5hf245c06db00b6127@mail.gmail.com>
References: <63386a3d0905181340y42ad1868k6b2978e586abc18d@mail.gmail.com>
	 <4A12C3B5.2050100@compulab.co.il>
	 <63386a3d0905190923t36d301c5hf245c06db00b6127@mail.gmail.com>
Date: Tue, 19 May 2009 22:56:16 +0530
Message-ID: <5d5443650905191026w22b0ff95j992e09923f55dd0a@mail.gmail.com>
Subject: Re: [PATCH 1/1] MFD: Add U300 AB3100 core support v2
From: Trilok Soni <soni.trilok@gmail.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Mike Rapoport <mike@compulab.co.il>, linux-kernel@vger.kernel.org,
       sameo@linux.intel.com, linux-i2c@vger.kernel.org,
       Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Tue, May 19, 2009 at 9:53 PM, Linus Walleij
<linus.ml.walleij@gmail.com> wrote:
> Hm I shouldn't been so trigger-happy as to send v3 out so soon... :-/
>
> Thanks for you quick review Mike!
>
> 2009/5/19 Mike Rapoport <mike@compulab.co.il>:
>
>>> +     /* Set a pointer back to the container in device data */
>>> +     for (i = 0; i < ARRAY_SIZE(ab3100_platform_devs); i++)
>>> +             platform_set_drvdata(ab3100_platform_devs[i], ab3100_local);
>>> +
>>> +     /* Register the platform devices */
>>> +     platform_add_devices(ab3100_platform_devs,
>>> +                          ARRAY_SIZE(ab3100_platform_devs));
>>
>> If you register sub-devices this way, they won't appear as ab3100 children.
>
> I'll set the parent in the first loop then (will test that this works) because I
> really like that device table. (Similar to how the board setup does things.)
>

I don't know but why people are not encouraging to use mfd_xxx apis
here? Lot's of drivers are available under drivers/mfd, but only
couple of them are using real mfd_xxx apis? Is there anything missing
in those apis?

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
