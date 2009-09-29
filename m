Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbZI2CUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbZI2CUR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 22:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbZI2CUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 22:20:16 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:63500 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834AbZI2CUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 22:20:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=HWWttGcr3F8GBF9OGrvJRUvR3/oLsWl2uJT/AUuKbVj3jHQBVhbkKoIHBfgtdQXn6x
         SWjcplCvTLE4HBFlD6ZoZPmU9y4weBrtgznYkvnheF95FUJo0H7qD6iYDayV774uyuRB
         sIBor7K1fadlDx6zfXusH9jhkFC1Lt+Ajc4Vw=
MIME-Version: 1.0
In-Reply-To: <20090928131700.GA19243@nb-core2.darkstar.lan>
References: <20090923191240.GA15198@dreamland.darkstar.lan>
	 <51f3faa70909232018v7e621190m84deb648b08d2135@mail.gmail.com>
	 <20090928131700.GA19243@nb-core2.darkstar.lan>
Date: Mon, 28 Sep 2009 20:20:18 -0600
Message-ID: <51f3faa70909281920x2782d8dfm1835ab24779abfa3@mail.gmail.com>
Subject: Re: [PATCH] asus_atk0110: add support for Asus P7P55D
From: Robert Hancock <hancockrwd@gmail.com>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       Jean Delvare <khali@linux-fr.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 7:17 AM, Luca Tettamanti <kronos.it@gmail.com> wrote:
> On Wed, Sep 23, 2009 at 09:18:45PM -0600, Robert Hancock wrote:
>> On Wed, Sep 23, 2009 at 1:12 PM, Luca Tettamanti <kronos.it@gmail.com> wrote:
>> > With P7P55D (and newer) boards Asus extended the output buffer (ASBF)
>> > making the driver unable to read the data from the sensors.
>> > Change the driver to use dynamic buffers (allocated by ACPI core); the
>> > return value is cached, so the number of memory allocations is very low.
>> >
>> > Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
>> > Tested-by: Robert Hancock <hancockrwd@gmail.com>
>>
>> I just noticed a problem (either with this patch or some other issue
>> with the driver on this board): The readings don't seem to be
>> updating, I get the same values all the time. (Just now I started
>> compiling a kernel and coretemp reports temperatures in the 60 degree
>> plus range but atk0110-acpi still reports 35 degrees as it did
>> before..)
>
> Hi Robert,
> I have a new patch for you :)
> It contains the previous changes to handle the bigger ASBF buffer plus a new
> method to enable the EC as suggested by Asus. Be sure to compile with
> HWMON_DEBUG_CHIP enabled.

Excellent.. seems to work now and give actually updating sensor readings :-)

By the way, if you have any firmware-type contacts at Asus that know
about these boards, you might want to point them at this problem, the
BIOS DMAR tables point to invalid locations when Intel VT-d is
enabled. So far haven't gotten any useful response from tech support..

http://www.gossamer-threads.com/lists/linux/kernel/1131574
