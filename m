Return-Path: <linux-kernel-owner+w=401wt.eu-S1752713AbZIOKrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbZIOKrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 06:47:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbZIOKrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 06:47:00 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:34533 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbZIOKrA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 06:47:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BU0XyF3IH3YghbgCGtGPasHwiT8XN5Ia5ecju9/RcM/jo4L6K7lwGAM2GyhEFSXe/+
         Ec4j4ahN1/9GaH0jCS9dbLf3QejhzRB7L5KjWqF+4CJjwIQZmrvZ6m5tUZ1B8ygnwdiF
         npxC+PaLWeq32Bblp83FPoNfTwOA4gwwZHr9c=
MIME-Version: 1.0
In-Reply-To: <20090915103739.GA19519@elf.ucw.cz>
References: <1252875960-21512-1-git-send-email-felipe.contreras@gmail.com>
	 <20090913230008.GC30169@n2100.arm.linux.org.uk>
	 <20090914002100.GD30621@shareable.org>
	 <20090914081001.GB14519@n2100.arm.linux.org.uk>
	 <94a0d4530909140558nd8d2c47lc9954563c80a574f@mail.gmail.com>
	 <20090914140059.GC21580@n2100.arm.linux.org.uk>
	 <94a0d4530909140738t7e4d646r134cfd884da21348@mail.gmail.com>
	 <20090914144028.GG21580@n2100.arm.linux.org.uk>
	 <94a0d4530909140814w36f7f5f0td2c25db07fbd4e57@mail.gmail.com>
	 <20090915103739.GA19519@elf.ucw.cz>
Date: Tue, 15 Sep 2009 13:47:01 +0300
Message-ID: <94a0d4530909150347h642772bvc8175109393e905f@mail.gmail.com>
Subject: Re: [PATCH] arm: remove unused code in delay.S
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Jamie Lokier <jamie@shareable.org>, Marek Vasut <marek.vasut@gmail.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 1:37 PM, Pavel Machek <pavel@ucw.cz> wrote:
>
>> >> > Because then you get it whenever you configure for V4 as the lowest
>> >> > denominator CPU, which leads to the buggy behaviour on better CPUs.
>> >> > It's far better to leave it as is and just accept that the old CPUs
>> >> > will have longer than necessary delays.  If people really really
>> >> > care (and there's likely to only be a small minority of them now)
>> >> > changing the '0' to a '1' is a very simple change for them to carry
>> >> > in their local tree.  Unlike getting the right unrolling etc.
>> >>
>> >> Well, they can also 'git revert' this patch. If somebody really cares
>> >> I think they should shout now and provide a better patch, otherwise
>> >> this one should be merged.
>> >
>> > On the other hand, having the code there as it currently stands is not
>> > harmful in any way, so leaving it there is just as easy.
>>
>> It makes the code less understandable. I'm not sure about linux's
>> practices, but an #if 0 generally means somebody is being lazy.
>
> Not in this case, as you was explained to you. You may want to add
> explaining comment above #if 0....

Yes, but I've no idea in which situations somebody might want to
enable that code. Old chips? Which old chips?

-- 
Felipe Contreras
