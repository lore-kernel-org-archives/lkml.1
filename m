Return-Path: <linux-kernel-owner+w=401wt.eu-S1753935AbZI3CIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbZI3CIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 22:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753680AbZI3CIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 22:08:50 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:65291 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbZI3CIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 22:08:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=vLRgkj9nDx05oQoPs39RUWkm8wqiXh3uoctc1NVhboGlq2HWT7TTWmm+Q5AIv55xp6
         Fq11+Cuse7eWzMKS0uaaLNAxJqv/GVvhypKZkzjF4hZdYouiaeXV2xWHIxp6w7rrOrck
         XLUCcJDiegJwHyCiusjpqCCeZ0f8TcYVG2olA=
MIME-Version: 1.0
In-Reply-To: <4AC21E7B.70000@mandriva.org>
References: <20090923191240.GA15198@dreamland.darkstar.lan>
	 <51f3faa70909232018v7e621190m84deb648b08d2135@mail.gmail.com>
	 <20090928131700.GA19243@nb-core2.darkstar.lan>
	 <51f3faa70909281920x2782d8dfm1835ab24779abfa3@mail.gmail.com>
	 <51f3faa70909282134o1d60efekeded09f09b192df6@mail.gmail.com>
	 <68676e00909290707u70d192f2j2f2d4dd07bd07234@mail.gmail.com>
	 <51f3faa70909290740l4f4df186w114bf48e1db3a948@mail.gmail.com>
	 <4AC21E7B.70000@mandriva.org>
Date: Tue, 29 Sep 2009 20:08:52 -0600
Message-ID: <51f3faa70909291908jdf1a081s831263f7c5e9b73c@mail.gmail.com>
Subject: Re: [PATCH] asus_atk0110: add support for Asus P7P55D
From: Robert Hancock <hancockrwd@gmail.com>
To: Thomas Backlund <tmb@mandriva.org>
Cc: Luca Tettamanti <kronos.it@gmail.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, Jean Delvare <khali@linux-fr.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 8:49 AM, Thomas Backlund <tmb@mandriva.org> wrote:
> Robert Hancock skrev:
>>
>> On Tue, Sep 29, 2009 at 8:07 AM, Luca Tettamanti <kronos.it@gmail.com>
>> wrote:
>>>>>>
>>>>>> Hi Robert,
>>>>>> I have a new patch for you :)
>>>>>> It contains the previous changes to handle the bigger ASBF buffer plus
>>>>>> a new
>>>>>> method to enable the EC as suggested by Asus. Be sure to compile with
>>>>>> HWMON_DEBUG_CHIP enabled.
>>>>>
>>>>> Excellent.. seems to work now and give actually updating sensor
>>>>> readings :-)
>>>>
>>>> Have seen a couple of these though, looks like about once an hour:
>>>>
>>>> ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl]
>>>> (20090903/evregion-424)
>>>> ACPI Error (psparse-0537): Method parse/execution failed
>>>> [\_SB_.PCI0.SBRG.ASOC.GIT6] (Node ffff88013ba778c0), AE_TIME
>>>> ACPI Error (psparse-0537): Method parse/execution failed
>>>> [\_SB_.PCI0.SBRG.ASOC.GITM] (Node ffff88013ba6ea40), AE_TIME
>>>> ATK0110 ATK0110:00: atk_read_value_new: ACPI exception: AE_TIME
>>>>
>>>> Maybe sometimes the embedded controller takes longer than the timeout
>>>> to process, or something?
>>>
>>> Is there a message like "input buffer is not empty" before that?
>>
>> Nope, that's all I'm getting each time it happens. Suggestions/debug
>> patches welcome..
>>
>
> Try this one:
> http://marc.info/?l=linux-kernel&m=125421276407283&w=2

I added this patch, no timeouts after 2 hours. Could be just chance
though, if it lasts till tomorrow evening it will be pretty
conclusive..
