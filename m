Return-Path: <linux-kernel-owner+w=401wt.eu-S1758665AbZHRKsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665AbZHRKsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 06:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758544AbZHRKsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 06:48:51 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:46649 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422AbZHRKsu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 06:48:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EA+Y6DZyRK0gduNHWvL9UZetoj87iFw2BnACypfLszIlPVKSEtEW1gvwP6skWbCaEU
         6AKLsiTEimnEwthxuVmSA7L6CurxIEDVGdrlrM6xluHmH71nFtPYNH3o+JBQsW3XKHcK
         gLBVaRQV1w4eC0nx0SDxdTMINUK2dqV4wp3h4=
MIME-Version: 1.0
In-Reply-To: <20090818104410.GO29655@pengutronix.de>
References: <20090814170228.GM13320@pengutronix.de>
	 <1158166a0908141304y70300ab3p899b0d4609efded9@mail.gmail.com>
	 <20090814204305.GA31727@pengutronix.de>
	 <20090815103532.GA5596@sig21.net> <4A8A7D38.5020201@gmail.com>
	 <20090818102136.GN29655@pengutronix.de>
	 <81b0412b0908180334u51fd957dh36f2a4946dffbb0b@mail.gmail.com>
	 <20090818104410.GO29655@pengutronix.de>
Date: Tue, 18 Aug 2009 12:48:50 +0200
Message-ID: <81b0412b0908180348n75af1113wb380919eaeaaf29b@mail.gmail.com>
Subject: Re: New fast(?)-boot results on ARM
From: Alex Riesen <raa.lkml@gmail.com>
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: Marco Stornelli <marco.stornelli@gmail.com>,
       Johannes Stezenbach <js@sig21.net>,
       Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>,
       Tim Bird <tim.bird@am.sony.com>, kernel@pengutronix.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 12:44, Robert Schwebel<r.schwebel@pengutronix.de> wrote:
> On Tue, Aug 18, 2009 at 12:34:52PM +0200, Alex Riesen wrote:
>> On Tue, Aug 18, 2009 at 12:21, Robert Schwebel<r.schwebel@pengutronix.de> wrote:
>> > - In general we want to have our systems close to what the mainline
>> >  does; Automation & Embedded is only a small market, and anything
>> >  which is *not* specific to these markets but mainline is good.
>>
>> BTW, what is your mainline (or it looks like you mean "upstream")?
>
> unpatched kernel.org
>

But many of the problems you described and suggested solutions
point at userspace, right? (like pre-defined static /dev, mdev script,
or using of specially designed rootfs)
