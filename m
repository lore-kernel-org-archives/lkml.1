Return-Path: <linux-kernel-owner+w=401wt.eu-S1751485AbZI1Nk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485AbZI1Nk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 09:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbZI1Nk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 09:40:26 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:62190 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbZI1NkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 09:40:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=NwL6W5+h0ttSULariWCVryYnSoeLxTialnDVmV1TCcutoHJDmFTf7lAupMIKbr4CPE
         IsUOVTHDZUQOGqJtAwgVl16OSm5T3U/FJb2rUascfw92l0jWZQ85wMa+KgTXRsEhzZpc
         xJhDnCZYaBwgqC52R45Js1ZRTjHns8JDDPfxg=
MIME-Version: 1.0
In-Reply-To: <20090928152210.593e5d48@hyperion.delvare>
References: <20090923191240.GA15198@dreamland.darkstar.lan>
	 <51f3faa70909232018v7e621190m84deb648b08d2135@mail.gmail.com>
	 <20090928131700.GA19243@nb-core2.darkstar.lan>
	 <20090928152210.593e5d48@hyperion.delvare>
Date: Mon, 28 Sep 2009 15:40:29 +0200
Message-ID: <68676e00909280640l5cd46c33kae00692801e17960@mail.gmail.com>
Subject: Re: [PATCH] asus_atk0110: add support for Asus P7P55D
From: Luca Tettamanti <kronos.it@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Robert Hancock <hancockrwd@gmail.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 3:22 PM, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Lucas,
>
> On Mon, 28 Sep 2009 15:17:00 +0200, Luca Tettamanti wrote:
>> I have a new patch for you :)
>> It contains the previous changes to handle the bigger ASBF buffer plus a new
>> method to enable the EC as suggested by Asus. Be sure to compile with
>> HWMON_DEBUG_CHIP enabled.
>
> Wow, that's a lot of code to just enable the EC, I hoped it would be
> more simple than this :(

A lot of that code is error checking ;-)

> Wouldn't it make sense to also disable the EC when the asus_atk0110
> driver is removed? To restore the chip to its initial state.

Yes, it makes sense.

L
