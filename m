Return-Path: <linux-kernel-owner+w=401wt.eu-S1755787Ab0AVCaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab0AVCaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 21:30:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755630Ab0AVCai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 21:30:38 -0500
Received: from mail-iw0-f196.google.com ([209.85.223.196]:33213 "EHLO
	mail-iw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167Ab0AVCah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 21:30:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=UYTieTGqjOGcIYWw7SNIE6yAviRtumlMOlPJE8k5wl3JiTPB4BW1mwEOGUt+blu/YN
         C4dUsan+GJFaYf/UTlV2RdYgVqAlTzY+DlhNdNdoE3qD6XCTpB4IYiwodHMzS+dM99P4
         rtCnbvWaMxD1qxLIri/iskVa+I/87vkVWZtWo=
MIME-Version: 1.0
In-Reply-To: <1264126146.28766.0.camel@localhost.localdomain>
References: <1264011793.1735.3683.camel@localhost.localdomain>
	 <4B57A2D4.9030204@gmail.com>
	 <20100121185544.GB11996@core.coreip.homeip.net>
	 <51f3faa71001211339t4652700ct34659c37479cd67e@mail.gmail.com>
	 <4B58CBEE.5020301@gmail.com>
	 <51f3faa71001211629n1b556649t32c184e49dc32dfb@mail.gmail.com>
	 <4B58FD48.9020209@gmail.com>
	 <1264126146.28766.0.camel@localhost.localdomain>
Date: Thu, 21 Jan 2010 20:30:36 -0600
Message-ID: <51f3faa71001211830s1744809eu3d3c5b7753656822@mail.gmail.com>
Subject: Re: [PATCH] Disable i8042 checks on Intel Apple Macs
From: Robert Hancock <hancockrwd@gmail.com>
To: Bastien Nocera <hadess@hadess.net>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, pjones@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 8:09 PM, Bastien Nocera <hadess@hadess.net> wrote:
> On Thu, 2010-01-21 at 17:20 -0800, Justin P. Mattock wrote:
>> On 01/21/10 16:29, Robert Hancock wrote:
> <snip>
>> > cat /sys/bus/pnp/devices/*/id
>> >
>> > and see if any of these are present?
>> >
>> > PNP0303
>> > PNP030b
>> > FJC6000
>> > FJC6001
>> > PNP0f03
>> > PNP0f0b
>> > PNP0f0e
>> > PNP0f12
>> > PNP0f13
>> > PNP0f19
>> > PNP0f1c
>> > SYN0801
>> >
>>
>>
>> both macbook pro, and iMac9,1
>> have:
>> PNP0a08
>> PNP0a03
>
> # cat /sys/bus/pnp/devices/*/id
> PNP0a08
> PNP0a03
> PNP0c02
> APP0001
> PNP0200
> INT0800
> PNP0103
> PNP0c01
> PNP0c04
> PNP0c02
> PNP0b00
>
> On a MacbookAir1,1

So it doesn't report any keyboard or mouse controller. You're sure
that "PNP: No PS/2 controller found" message doesn't show up?
