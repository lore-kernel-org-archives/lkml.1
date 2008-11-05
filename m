Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbYKEJjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbYKEJjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 04:39:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754291AbYKEJiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 04:38:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:48777 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754227AbYKEJit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 04:38:49 -0500
Message-ID: <49116966.7040403@kernel.org>
Date: Wed, 05 Nov 2008 18:37:42 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Elias Oltmanns <eo@nebensachen.de>
CC: Robert Hancock <hancockr@shaw.ca>, Mark Lord <liml@rtr.ca>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata hibernation fixes
References: <fa.Ast7pgG6P20u1PcyOsfgzoaX5YA@ifi.uio.no>	<fa.1+JQHm7yjIiZJxAzR0eBPn39a9M@ifi.uio.no>	<fa.+bfipgmFkcLlZMtnFL0Ks2zyN8Q@ifi.uio.no>	<fa.Iek0GbTZLinM2sOi6+b7bsCgnfs@ifi.uio.no> <4910E240.4000801@shaw.ca>	<87abcfdmpp.fsf@denkblock.local> <4911053E.9070103@kernel.org> <874p2mecyr.fsf@denkblock.local>
In-Reply-To: <874p2mecyr.fsf@denkblock.local>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 05 Nov 2008 09:37:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elias Oltmanns wrote:
> Tejun Heo <tj@kernel.org> wrote:
>> Elias Oltmanns wrote:
>>>> On these systems, not spinning the disk down is fine because the BIOS
>>>> does it. However this would cause problems on systems where the BIOS
>>>> doesn't do so as it will cause an emergency unload on power-down.
>>> Ah, but do BIOSes just cut power without spinning disks down first?
>>> Pressing the power button on my laptop either at the prompt for the HD
>>> password or in GRUB's menu spins the disk down properly. Isn't that the
>>> BIOS doing its job?
>> Drives don't like emergency unloads but they are designed to take
>> some.
> 
> In the situations I mentioned above, the drive definitely is not
> performing an emergency unload. On the other hand, the BIOS hasn't
> handed over control to the OS at this stage, so it would make sense if
> the BIOS behaved differently once the OS has taken over.

Yeah, that was what I was talking about later in my email, but generally
I don't really think it's worth the trouble.

> BTW, what exactly will happen if I install an ancient OS like DOS on my
> (reasonably) modern laptop? I've never tried that but I don't see how
> the OS would even have a chance to spin the disk down befor power off
> since there is no way for the user to initiate power off in the OS. Is
> that anything to do with ACPI support?

DOS had a lot of fun parking programs.  ACPI doesn't have much to do
with it although the BIOS can use it to stay out of OS's way if the OS
is calling ACPI to power the machine down.

Thanks.

-- 
tejun
