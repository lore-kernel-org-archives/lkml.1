Return-Path: <linux-kernel-owner+w=401wt.eu-S1755560AbYKEJbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbYKEJbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 04:31:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbYKEJba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 04:31:30 -0500
Received: from nebensachen.de ([195.34.83.29]:60158 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585AbYKEJb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 04:31:28 -0500
X-Hashcash: 1:20:081105:tj@kernel.org::3ZZlUCqAKwUEfUvW:00000bRK
X-Hashcash: 1:20:081105:hancockr@shaw.ca::XYScl36SDzajtX1L:04tv7
X-Hashcash: 1:20:081105:liml@rtr.ca::iiUE3mlccOPFA4Qz:0000000eDx
X-Hashcash: 1:20:081105:rjw@sisk.pl::83EBzNOMlyXj6wH5:0000003mIz
X-Hashcash: 1:20:081105:torvalds@linux-foundation.org::04g3mtJ2/225qXMw:000000000000000000000000000000008amd
X-Hashcash: 1:20:081105:jeff@garzik.org::0u0/sOm198qelL3b:003XJo
X-Hashcash: 1:20:081105:akpm@linux-foundation.org::rwQL9lhhZ9slkIpa:0000000000000000000000000000000000003NTD
X-Hashcash: 1:20:081105:linux-ide@vger.kernel.org::qxL0heLM5rC1/QWJ:0000000000000000000000000000000000000xuN
X-Hashcash: 1:20:081105:linux-kernel@vger.kernel.org::WrMWTMmH2pHWMXYv:0000000000000000000000000000000004h2J
From: Elias Oltmanns <eo@nebensachen.de>
To: Tejun Heo <tj@kernel.org>
Cc: Robert Hancock <hancockr@shaw.ca>, Mark Lord <liml@rtr.ca>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata hibernation fixes
References: <fa.Ast7pgG6P20u1PcyOsfgzoaX5YA@ifi.uio.no>
	<fa.1+JQHm7yjIiZJxAzR0eBPn39a9M@ifi.uio.no>
	<fa.+bfipgmFkcLlZMtnFL0Ks2zyN8Q@ifi.uio.no>
	<fa.Iek0GbTZLinM2sOi6+b7bsCgnfs@ifi.uio.no> <4910E240.4000801@shaw.ca>
	<87abcfdmpp.fsf@denkblock.local> <4911053E.9070103@kernel.org>
Date: Wed, 05 Nov 2008 10:31:08 +0100
In-Reply-To: <4911053E.9070103@kernel.org> (Tejun Heo's message of "Wed, 05
	Nov 2008 11:30:22 +0900")
Message-ID: <874p2mecyr.fsf@denkblock.local>
User-Agent: Gnus/5.110011 (No Gnus v0.11)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> wrote:
> Elias Oltmanns wrote:
>>> On these systems, not spinning the disk down is fine because the BIOS
>
>>> does it. However this would cause problems on systems where the BIOS
>>> doesn't do so as it will cause an emergency unload on power-down.
>> 
>> Ah, but do BIOSes just cut power without spinning disks down first?
>> Pressing the power button on my laptop either at the prompt for the HD
>> password or in GRUB's menu spins the disk down properly. Isn't that the
>> BIOS doing its job?
>
> Drives don't like emergency unloads but they are designed to take
> some.

In the situations I mentioned above, the drive definitely is not
performing an emergency unload. On the other hand, the BIOS hasn't
handed over control to the OS at this stage, so it would make sense if
the BIOS behaved differently once the OS has taken over. BTW, what
exactly will happen if I install an ancient OS like DOS on my
(reasonably) modern laptop? I've never tried that but I don't see how
the OS would even have a chance to spin the disk down befor power off
since there is no way for the user to initiate power off in the OS. Is
that anything to do with ACPI support?

Regards,

Elias
