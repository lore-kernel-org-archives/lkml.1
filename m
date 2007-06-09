Return-Path: <linux-kernel-owner+w=401wt.eu-S1760595AbXFIUi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760595AbXFIUi5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 16:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757782AbXFIUiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 16:38:50 -0400
Received: from pythagoras.zen.co.uk ([212.23.3.140]:45118 "EHLO
	pythagoras.zen.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757628AbXFIUit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 16:38:49 -0400
Message-ID: <466B0FD7.8050702@gmail.com>
Date: Sat, 09 Jun 2007 21:38:47 +0100
From: Matt Keenan <tank.en.mate@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Andrew Lyon <andrew.lyon@gmail.com>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Re: 4Gb ram not showing up
References: <Pine.LNX.4.58.0706061356310.2657@be1.lrz>	 <20070606143723.GF10008@csclub.uwaterloo.ca>	 <46673135.30105@zytor.com>	 <f4527be0706061541ifd49a8fg60442532d72f1d06@mail.gmail.com>	 <46682FED.2080506@zytor.com> <f4527be0706071037l5278fe61v1a733ab874aec136@mail.gmail.com>
In-Reply-To: <f4527be0706071037l5278fe61v1a733ab874aec136@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-Pythagoras-IP: [82.69.27.224]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Lyon wrote:
> On 6/7/07, H. Peter Anvin <hpa@zytor.com> wrote:
>> Andrew Lyon wrote:
>> >
>> > Could this also cause a system to be unstable? my abit athlon64 at
>> > work will not run x64 with more than 1gb ram, and i have a colo server
>> > with supermicro & 2 x dual core xeons that will not run with more than
>> > 2gb.
>> >
>> > Both systems have long uptimes but if i add ram they crash within
>> > minutes of booting.
>> >
>>
>> That's much more likely to be caused by bad memory bus layout so that it
>> doesn't handle the higher loading.
>>
>> Run memtest86+ on the expanded memory for some time.
>>
>>         -hpa
>>
>
> I have run memtest86+ for days at a time on both systems with no
> errors at all.
>
> broken hardware i guess, i am not surprised about the abit board, ive
> had nothing but trouble with abit motherboards and do not use them any
> more, but the supermicro is a xeon server board and i was using
> kingston ram, i wouldnt expect that to have issues.
I have had problems with kingston ram and heavily populated boards
(being ASUS boards didn't help either).  I have found through trial and
error that gigabyte and/or msi boards with crucial memory seems to work
the best, and for servers i always buy low latency ecc ram, even if it
is a slower frequency.  I also had problems with machines that passed
memtest but failed in real life.. you may also want to check your power
supply and make sure you buy boards with multiple (6 or more) voltage
regulators.

Matt
