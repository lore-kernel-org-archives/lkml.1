Return-Path: <linux-kernel-owner+w=401wt.eu-S1761535AbXE2Lkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761535AbXE2Lkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 07:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbXE2Lkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 07:40:47 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47930 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750792AbXE2Lkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 07:40:47 -0400
Date: Tue, 29 May 2007 13:40:43 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Michael-Luke Jones <mlj28@cam.ac.uk>
Cc: Nitin Gupta <nitingupta910@gmail.com>,
       Daniel Hazelton <dhazelton@enter.net>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm-cc@laptop.org,
       linuxcompressed-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Richard Purdie <richard@openedhand.com>, Bret Towe <magnade@gmail.com>
Subject: Re: [RFC] LZO de/compression support - take 6
Message-ID: <20070529114043.GR3899@stusta.de>
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com> <4cefeab80705280740l36c00bf8t4a6f5b426a7a380a@mail.gmail.com> <200705281049.48679.dhazelton@enter.net> <4cefeab80705280806m39fbcfd6v93a1c847c25e381c@mail.gmail.com> <20070528171115.GQ3899@stusta.de> <7A4314A3-24D8-49E2-BEEF-D760595255A2@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7A4314A3-24D8-49E2-BEEF-D760595255A2@cam.ac.uk>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 09:08:27AM +0100, Michael-Luke Jones wrote:
> On 28 May 2007, at 18:11, Adrian Bunk wrote:
>
>> I have not seen any explanations:
>> - Why did the upstream author write the code that way?
>
> Apparently due to his requirement for extreme portability. The original 
> code was designed to work on everything from 16-bit DOS through CRAY 
> supercomputers through Windows, Unices and Linux.

Sure, this could be the reason in some or all cases.

The upstream author knows the code best, and discussing such issues with 
him will in many cases be a win:

It could be that there was in some cases no good reason, and the 
upstream code that gets used by many other projects could become faster.

Or there was a good reason that applies also to the in-kernel version 
and a change breaks some corner case.

> The author has stated on the thread that it's a good idea to remove 
> unnecessary ifdefs when porting the code into the kernel, given that the 
> portability requirements are obviously no longer needed.

"remove unnecessary ifdefs" implies "generated code is identical".

That's quite different from "code is 10% faster".

> Michael-Luke

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

