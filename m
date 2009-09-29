Return-Path: <linux-kernel-owner+w=401wt.eu-S1752893AbZI2OkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbZI2OkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 10:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbZI2OkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 10:40:04 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:42853 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbZI2OkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 10:40:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Yx7wx9Nj+7zkf5J48kBii9f6NZvgLsoiewHrDcMT1qP8mcSJ+QiSwpdZ6dtJ7nnDbT
         pvcsda6ULoFMYog5B1YoomX5LtU1kzok76kQVXT4tFLk+bqdgTDKUe1UyTx4BCLTCLkA
         D+JfhcQJBdW/NCFH3a9elkgB+ma+jsnEK9UlA=
MIME-Version: 1.0
In-Reply-To: <68676e00909290707u70d192f2j2f2d4dd07bd07234@mail.gmail.com>
References: <20090923191240.GA15198@dreamland.darkstar.lan>
	 <51f3faa70909232018v7e621190m84deb648b08d2135@mail.gmail.com>
	 <20090928131700.GA19243@nb-core2.darkstar.lan>
	 <51f3faa70909281920x2782d8dfm1835ab24779abfa3@mail.gmail.com>
	 <51f3faa70909282134o1d60efekeded09f09b192df6@mail.gmail.com>
	 <68676e00909290707u70d192f2j2f2d4dd07bd07234@mail.gmail.com>
Date: Tue, 29 Sep 2009 08:40:07 -0600
Message-ID: <51f3faa70909290740l4f4df186w114bf48e1db3a948@mail.gmail.com>
Subject: Re: [PATCH] asus_atk0110: add support for Asus P7P55D
From: Robert Hancock <hancockrwd@gmail.com>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       Jean Delvare <khali@linux-fr.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 8:07 AM, Luca Tettamanti <kronos.it@gmail.com> wrote:
>>>> Hi Robert,
>>>> I have a new patch for you :)
>>>> It contains the previous changes to handle the bigger ASBF buffer plus a new
>>>> method to enable the EC as suggested by Asus. Be sure to compile with
>>>> HWMON_DEBUG_CHIP enabled.
>>>
>>> Excellent.. seems to work now and give actually updating sensor readings :-)
>>
>> Have seen a couple of these though, looks like about once an hour:
>>
>> ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl]
>> (20090903/evregion-424)
>> ACPI Error (psparse-0537): Method parse/execution failed
>> [\_SB_.PCI0.SBRG.ASOC.GIT6] (Node ffff88013ba778c0), AE_TIME
>> ACPI Error (psparse-0537): Method parse/execution failed
>> [\_SB_.PCI0.SBRG.ASOC.GITM] (Node ffff88013ba6ea40), AE_TIME
>> ATK0110 ATK0110:00: atk_read_value_new: ACPI exception: AE_TIME
>>
>> Maybe sometimes the embedded controller takes longer than the timeout
>> to process, or something?
>
> Is there a message like "input buffer is not empty" before that?

Nope, that's all I'm getting each time it happens. Suggestions/debug
patches welcome..

>
>>> By the way, if you have any firmware-type contacts at Asus that know
>>> about these boards, you might want to point them at this problem, the
>>> BIOS DMAR tables point to invalid locations when Intel VT-d is
>>> enabled. So far haven't gotten any useful response from tech support..
>
> I don't have any inside contact, sorry (and I agree with dwmw2 :P)
>
> L
>
