Return-Path: <linux-kernel-owner+w=401wt.eu-S1752913AbZIGNG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbZIGNG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 09:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbZIGNG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 09:06:26 -0400
Received: from mail-vw0-f195.google.com ([209.85.212.195]:55094 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbZIGNGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 09:06:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=eIlnieGNIXm7Uq+LeknluzhudOfCW6DbASvo6T23Sxdn70zwh/FKbZJL3MSfd8czxa
         yS0sBNU9Z0MczjcZ7T1ge2zFFU1CDr27EauSzRc2lPD/LxILMRckyyBtSIU6BOhRfhGl
         355yCaacmVL+Alje3fB2O4bbn/J/4KQiOgfWU=
MIME-Version: 1.0
In-Reply-To: <5d5443650909070526w463838d5u69fff7a5c7d435a6@mail.gmail.com>
References: <5d5443650908221004y5b893382m368dc18a38636c1b@mail.gmail.com>
	 <4A902904.2090008@gmail.com>
	 <9c9fda240908222145j1938baa3v3ecf8c5899ce3850@mail.gmail.com>
	 <5d5443650908230051wa8fa77cu280707281fe450ff@mail.gmail.com>
	 <5d5443650909070429q1eeb5b78t8398ba670143fbf9@mail.gmail.com>
	 <4AA4F21E.5080400@samsung.com>
	 <5d5443650909070526w463838d5u69fff7a5c7d435a6@mail.gmail.com>
Date: Mon, 7 Sep 2009 22:06:27 +0900
X-Google-Sender-Auth: ac40d61e50a76439
Message-ID: <9c9fda240909070606v6c5b59aan26a7edd173e2205d@mail.gmail.com>
Subject: Re: haptics devices linux driver support
From: Kyungmin Park <kmpark@infradead.org>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>, Jiri Slaby <jirislaby@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 7, 2009 at 9:26 PM, Trilok Soni<soni.trilok@gmail.com> wrote:
> Hi Joonyoung Shim,
>
> On Mon, Sep 7, 2009 at 5:14 PM, Joonyoung Shim<jy0922.shim@samsung.com> wrote:
>> On 9/7/2009 8:29 PM, Trilok Soni wrote:
>>> Hi Kyungmin,
>>>
>>> On Sun, Aug 23, 2009 at 1:21 PM, Trilok Soni<soni.trilok@gmail.com> wrote:
>>>> Hi Kyungmin,
>>>>
>>>> On Sun, Aug 23, 2009 at 10:15 AM, Kyungmin Park<kmpark@infradead.org> wrote:
>>>>> Hi,
>>>>>
>>>>> There's three types as I know,
>>>>>
>>>>> 1) just GPIO enable motor
>>>>> 2) GPIO & PWM motor.
>>>>> 3) I2C based GPIO & PWM motor.
>>>>>
>>>>> Frankly we made a motor framework at kernel. but I 'm not sure motor
>>>>> is right naming or not.
>>>>> I think we need new framework. since it's not input device.
>>>> I am looking at 3rd type, and evaulating that for embedded systems
>>>> devices having haptics chips can be programmed under drivers/input or
>>>> not. It is kind of early discussion and gathering inputs on what could
>>>> be lacking part in input subsystem for support such category of
>>>> devices.
>>>>
>>>> Is it possible for you to submit your version of code and drivers? It
>>>> will be good starting point for discussion.
>>>
>>> Any updates on my request ?
>>>
>>
>> Hi, I will post the haptic framework soon(maybe tomorrow) instead of
>> Kyungmin because he leaves a office for days.
>
> Excellent. I just came back from vacation :)
>

FYI: I already finished the i2c based pwm & gpio devices. but I'm not
sure can release it at this time since we need to review it
internally.

Do you hear any patent issue? Since just one vendor (V company) has
almost patents related with vibrators.

Please find out the these.

Thank you,
Kyungmin Park
