Return-Path: <linux-kernel-owner+w=401wt.eu-S1757598AbYFZT1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598AbYFZT1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbYFZT1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:27:00 -0400
Received: from mxl.seznam.cz ([77.75.72.44]:32937 "EHLO mxl.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547AbYFZT07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:26:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=seznam.cz;
	h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Smtpd:X-Seznam-User:X-QM-Mark;
	b=emaf6wLit/jMmgoUYn4uEt5FO7SdD73a+JPCSvrlYmEFLvu0VUeOwmqyvOxiwhBb2
	9NEHqcrrtIm/O0aR0XoP2UeE2X4/+vgub8xaSsmcXt5WxPoZGl/SU9bM7qdZBHzf4gJ
	qDPa4T4hT3LXlZH2d05zCxG8rc4vjlqwMuNeLcA=
Message-ID: <4863EDB2.2040701@seznam.cz>
Date: Thu, 26 Jun 2008 21:27:46 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: linux-arch@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       Michal Simek <monstr@monstr.eu>, vapier.adi@gmail.com, arnd@arndb.de,
       matthew@wil.cx, microblaze-uclinux@itee.uq.edu.au,
       linux-kernel@vger.kernel.org, drepper@redhat.com,
       linuxppc-dev@ozlabs.org, will.newton@gmail.com, hpa@zytor.com,
       John.Linn@xilinx.com, john.williams@petalogix.com
Subject: Re: [PATCH 07/60] microblaze_v4: Support for semaphores
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>	<1214483429-32360-2-git-send-email-monstr@seznam.cz>	<1214483429-32360-3-git-send-email-monstr@seznam.cz>	<1214483429-32360-4-git-send-email-monstr@seznam.cz>	<1214483429-32360-5-git-send-email-monstr@seznam.cz>	<1214483429-32360-6-git-send-email-monstr@seznam.cz>	<1214483429-32360-7-git-send-email-monstr@seznam.cz>	<1214483429-32360-8-git-send-email-monstr@seznam.cz> <20080626143652.GD30954@cs181140183.pp.htv.fi>
In-Reply-To: <20080626143652.GD30954@cs181140183.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-Smtpd: 1.1.1@13338
X-Seznam-User: monstr@seznam.cz
X-QM-Mark: email-qm2<174362084>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK. I'do it.

M

> On Thu, Jun 26, 2008 at 02:29:36PM +0200, monstr@seznam.cz wrote:
>> From: Michal Simek <monstr@monstr.eu>
>>
>>
>> Signed-off-by: Michal Simek <monstr@monstr.eu>
>> ---
>>  include/asm-microblaze/semaphore.h |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>  create mode 100644 include/asm-microblaze/semaphore.h
>>
>> diff --git a/include/asm-microblaze/semaphore.h b/include/asm-microblaze/semaphore.h
>> new file mode 100644
>> index 0000000..d9b2034
>> --- /dev/null
>> +++ b/include/asm-microblaze/semaphore.h
>> @@ -0,0 +1 @@
>> +#include <linux/semaphore.h>
> 
> In -next all asm/semaphore.h headers gained a
>   #warning Use linux/semaphore.h, not asm/semaphore.h
> and the number of asm/semaphore.h is approaching zero.
> 
> You can simply drop this patch.
> 
> cu
> Adrian
> 
> 
> 
> ------------------------------------------------------------------------
> 
> 
> No virus found in this incoming message.
> Checked by AVG. 
> Version: 8.0.101 / Virus Database: 270.4.1/1519 - Release Date: 25.6.2008 04:13

