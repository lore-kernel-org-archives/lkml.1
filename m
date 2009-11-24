Return-Path: <linux-kernel-owner+w=401wt.eu-S932640AbZKXKVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640AbZKXKVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 05:21:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932587AbZKXKVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 05:21:07 -0500
Received: from mail-bw0-f223.google.com ([209.85.218.223]:45550 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509AbZKXKVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 05:21:05 -0500
Message-ID: <4B0BB393.4050302@monstr.eu>
Date: Tue, 24 Nov 2009 11:21:07 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       grant.likely@secretlab.ca, john.williams@petalogix.com,
       stable@kernel.org, chrisw@sous-sol.org, greg@kroah.com,
       alonz@discretix.com
Subject: Re: [PATCH] serial: 8250: Add ns16550a to OF compatible list
References: <1259054502-28284-1-git-send-email-monstr@monstr.eu> <1259054502-28284-2-git-send-email-monstr@monstr.eu> <200911240953.52204.arnd@arndb.de>
In-Reply-To: <200911240953.52204.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Tuesday 24 November 2009 09:21:42 monstr@monstr.eu wrote:
>> From: Michal Simek <monstr@monstr.eu>
>>
>> Signed-off-by: Michal Simek <monstr@monstr.eu>
> 
> I was holding off on that patch to make sure the discussion had ended,
> but this part certainly looks good.

:-) it is my next branch - I don't want to propose this patch through my 
tree.

> 
> Some points on form though:
> 
> * The patch is missing a changelog, which is always required, but especially
> important if you're changing code that you want in -stable!

it is simple almost trivial patch but if you like I can write there some 
background.

> 
> * You did not cc me. Ok, I just noticed I'm missing an entry in the MAINTAINERS
> file, but scripts/get_maintainer.pl would have given you a good indication of
> who feels responsible. You also didn't cc Alon, who submitted a similar patch
> [1] just days ago, which I assume prompted you to send this. If you didn't see
> his patch, nevermind.

you are not there. I have never used get_maintainer.pl script - will do.

I haven't seen his patch in LKML. Which subject?

$ ./scripts/get_maintainer.pl -f drivers/serial/8250.c
Alan Cox <alan@linux.intel.com>
Andrew Morton <akpm@linux-foundation.org>
David Daney <ddaney@caviumnetworks.com>
Tomaso Paoletti <tpaoletti@caviumnetworks.com>
Greg Kroah-Hartman <gregkh@suse.de>
linux-serial@vger.kernel.org
linux-kernel@vger.kernel.org


> 
> * Patches go into mainline first, then into stable [2]. Asking for inclusion into
> -stable for a patch that is still being discussed for inclusion in -next is
> the wrong order, no matter how obvious and trivial the patch is.

ok - sorry.

> 
> Anyway, thanks for the patch. I'll follow up with a new version with a better
> changelog for the tty tree. Any suggestions about what to do on 2.6.32?
> Should it go in there now, or would this go into a -stable release since
> it's not a regression?

cool thanks.

Michal

> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> [1] http://www.mail-archive.com/linuxppc-dev@lists.ozlabs.org/msg39015.html
> [2] http://lkml.indiana.edu/hypermail/linux/kernel/0504.3/1369.html
> 
>> ---
>>  drivers/serial/of_serial.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/serial/of_serial.c b/drivers/serial/of_serial.c
>> index 02406ba..b047c38 100644
>> --- a/drivers/serial/of_serial.c
>> +++ b/drivers/serial/of_serial.c
>> @@ -161,6 +161,7 @@ static int of_platform_serial_remove(struct of_device *ofdev)
>>  static struct of_device_id __devinitdata of_platform_serial_table[] = {
>>  	{ .type = "serial", .compatible = "ns8250",   .data = (void *)PORT_8250, },
>>  	{ .type = "serial", .compatible = "ns16450",  .data = (void *)PORT_16450, },
>> +	{ .type = "serial", .compatible = "ns16550a",  .data = (void *)PORT_16550A, },
>>  	{ .type = "serial", .compatible = "ns16550",  .data = (void *)PORT_16550, },
>>  	{ .type = "serial", .compatible = "ns16750",  .data = (void *)PORT_16750, },
>>  	{ .type = "serial", .compatible = "ns16850",  .data = (void *)PORT_16850, },
>>


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
