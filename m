Return-Path: <linux-kernel-owner+w=401wt.eu-S1760563AbXIQWCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760563AbXIQWCz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 18:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756406AbXIQWCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 18:02:47 -0400
Received: from mail.tmr.com ([64.65.253.246]:50911 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755443AbXIQWCq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 18:02:46 -0400
Message-ID: <46EEFA34.9000508@tmr.com>
Date: Mon, 17 Sep 2007 18:05:40 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: =?ISO-8859-1?Q?D=E2niel_Fraga?= <fragabr@gmail.com>
CC: linux-dvb@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Userspace tuner
References: <46C1BCC5.9090709@amd.com> <1189626560.5160.57.camel@gaivota>	<d9def9db0709121546h67d3d1ceuf001ab1d798fde92@mail.gmail.com>	<d9def9db0709121610n1a78225cs26380b7ca586344a@mail.gmail.com> <rjsmr4-rc8.ln1@tux.abusar.org>
In-Reply-To: <rjsmr4-rc8.ln1@tux.abusar.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dâniel Fraga wrote:
> 	Well, I'd like to see Linus' opinion about this, because while
> programmers keep discussing this, users are waiting forever... so if
> Markus has a concrete and better solution, why don't use it?
> 
> 	And as far as I know, Markus is the programmer who is most
> interested in this code. I didn't see anybody else in the world doing
> his work...
> 
> 	And I always had a impression that if most of things could be
> done in user space, than it will be better (for example, devfs -> udev).
> Why do everything in kernel space? Lets put *less* code in the kernel,
> not more code. And besides that, code in user space can be changed
> easily. Code in kernel has to wait a long time for Linus to accept (*if*
> he accepts).
> 
The problem with user space drivers is that it encourages binary only 
drivers, drivers which work only for a limited set of hardware, and 
other means to reduce choice for the user. There's a reason why binary 
modules make the kernel tainted, I have to feel that this is more and 
worse of same.

Linus will have an opinion, no doubt.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

