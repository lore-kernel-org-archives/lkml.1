Return-Path: <linux-kernel-owner+w=401wt.eu-S1758261AbZCYI4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261AbZCYI4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 04:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbZCYI4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 04:56:35 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:59425 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbZCYI4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 04:56:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EKqD5hLuFyrUNBGVp5juzuypIEqvCVgjTWYnUUOXVeFfNRjsLhpVunElAJxOz3aPEm
         TOGoj8E9itK+P0CjuLG/Bl12Fr2ETpnxHvA4QM/Bh5bVVeAoINi52XqaluOZjixqx0ep
         0P5IZUGAKy3CSJ0HvrfEU6dqpQf8WFWZbuDjg=
MIME-Version: 1.0
In-Reply-To: <49C84060.6010903@mnementh.co.uk>
References: <20090311125845.1563.31960.sendpatchset@rx1.opensource.se>
	 <20090316193010.56644165@mjolnir.ossman.eu>
	 <aec7e5c30903171858w12a9ee5bl4f3590d1a25a9971@mail.gmail.com>
	 <49C84060.6010903@mnementh.co.uk>
Date: Wed, 25 Mar 2009 17:56:31 +0900
Message-ID: <aec7e5c30903250156v1eb38bd7qafe1c4236d9daef@mail.gmail.com>
Subject: Re: [PATCH 00/05] tmio_mmc: Minor fixes and cnf/irq changes
From: Magnus Damm <magnus.damm@gmail.com>
To: Ian Molton <ian@mnementh.co.uk>
Cc: Pierre Ossman <drzeus@drzeus.cx>, linux-kernel@vger.kernel.org,
       drzeus-wbsd@drzeus.cx, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 11:07 AM, Ian Molton <ian@mnementh.co.uk> wrote:
> Magnus Damm wrote:
>
>> Thanks for your help. I was hoping on getting patch 3 and 4 included
>> in 2.6.30 as well if possible. I suspect that i have to rework them a
>> bit first though. That's no problem. Just let me know how you guys
>> prefer things and i'll resend.
>
> Can you clarify how your platform actually controls the MMC clock? does it
> at all?

I don't know. The block is embedded in an SoC and I have no
documentation. I assume there is some kind of clock hooked up to the
hardware block, and making use of that should be quite simple since we
already have clock framework support in place for the processor.

> what is your platform?

With tmio_mmc and the posted patches in this series I can use some
platform data to improve MMC performance. So far MMC support looks
like this:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=70e5c4f0843c3021a2e95b46edd8925a885d2e31

I think the MMC performance can be improved about 100x with tmio_mmc,
so it would be great to get this working. =)

> Ideally, the MMC code would use the clock API for some of this, but I seem
> to remember there were issues with this (cant recall what right now and its
> 2:05 AM).

No worries. For me the clock framework would be the best fit too. Not
sure about the exact details right now, but I _do_ know that we right
now we have nothing, so being able to use tmio_mmc as is (with posted
patches) is a great step forward. Working out the clock framework
details after that should be no biggie. Step by step.

Or if you want me to rewrite things that's fine as well. Just let me
know what to do. =)

Thanks for your help!

/ magnus
