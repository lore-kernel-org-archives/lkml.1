Return-Path: <linux-kernel-owner+w=401wt.eu-S1752968AbZI2Ota@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbZI2Ota (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 10:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbZI2Ot3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 10:49:29 -0400
Received: from mbox2.netikka.net ([213.250.81.203]:57093 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbZI2Ot2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 10:49:28 -0400
Message-ID: <4AC21E7B.70000@mandriva.org>
Date: Tue, 29 Sep 2009 17:49:31 +0300
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090830)
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: Luca Tettamanti <kronos.it@gmail.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] asus_atk0110: add support for Asus P7P55D
References: <20090923191240.GA15198@dreamland.darkstar.lan>	 <51f3faa70909232018v7e621190m84deb648b08d2135@mail.gmail.com>	 <20090928131700.GA19243@nb-core2.darkstar.lan>	 <51f3faa70909281920x2782d8dfm1835ab24779abfa3@mail.gmail.com>	 <51f3faa70909282134o1d60efekeded09f09b192df6@mail.gmail.com>	 <68676e00909290707u70d192f2j2f2d4dd07bd07234@mail.gmail.com> <51f3faa70909290740l4f4df186w114bf48e1db3a948@mail.gmail.com>
In-Reply-To: <51f3faa70909290740l4f4df186w114bf48e1db3a948@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock skrev:
> On Tue, Sep 29, 2009 at 8:07 AM, Luca Tettamanti <kronos.it@gmail.com> wrote:
>>>>> Hi Robert,
>>>>> I have a new patch for you :)
>>>>> It contains the previous changes to handle the bigger ASBF buffer plus a new
>>>>> method to enable the EC as suggested by Asus. Be sure to compile with
>>>>> HWMON_DEBUG_CHIP enabled.
>>>> Excellent.. seems to work now and give actually updating sensor readings :-)
>>> Have seen a couple of these though, looks like about once an hour:
>>>
>>> ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl]
>>> (20090903/evregion-424)
>>> ACPI Error (psparse-0537): Method parse/execution failed
>>> [\_SB_.PCI0.SBRG.ASOC.GIT6] (Node ffff88013ba778c0), AE_TIME
>>> ACPI Error (psparse-0537): Method parse/execution failed
>>> [\_SB_.PCI0.SBRG.ASOC.GITM] (Node ffff88013ba6ea40), AE_TIME
>>> ATK0110 ATK0110:00: atk_read_value_new: ACPI exception: AE_TIME
>>>
>>> Maybe sometimes the embedded controller takes longer than the timeout
>>> to process, or something?
>> Is there a message like "input buffer is not empty" before that?
> 
> Nope, that's all I'm getting each time it happens. Suggestions/debug
> patches welcome..
> 

Try this one:
http://marc.info/?l=linux-kernel&m=125421276407283&w=2

--
Thomas
