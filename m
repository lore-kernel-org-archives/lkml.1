Return-Path: <linux-kernel-owner+w=401wt.eu-S937128AbXG1IAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937128AbXG1IAS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 04:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763611AbXG1IAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 04:00:05 -0400
Received: from mail.trixing.net ([87.230.125.58]:47915 "EHLO mail.trixing.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763389AbXG1IAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 04:00:01 -0400
Message-ID: <46AAF709.9060407@l4x.org>
Date: Sat, 28 Jul 2007 09:58:01 +0200
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.10) Gecko/20070329 Thunderbird/1.5.0.10 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Andreas Schwab <schwab@suse.de>
CC: Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>
References: <200707251238.50218.lenb@kernel.org> <46A98FF9.8060801@l4x.org> <je8x91flu9.fsf@sykes.suse.de>
In-Reply-To: <je8x91flu9.fsf@sykes.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.195
X-SA-Exim-Mail-From: jdi@l4x.org
Subject: Re: [GIT PATCH] ACPI patches for 2.6.23-rc1
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:51:29 +0000)
X-SA-Exim-Scanned: Yes (on mail.trixing.net)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab wrote:
> Jan Dittmer <jdi@l4x.org> writes:
> 
>> Len Brown wrote:
>>> Hi Linus,
>>>
>>> please pull from: 
>>>
>>> git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release
>> This seems to break ia64 defconfig:
>>
>>   Building modules, stage 2.
>>   MODPOST 157 modules
>> FATAL: drivers/acpi/button: sizeof(struct acpi_device_id)=20 is not a modulo of the size of section __mod_acpi_device_table=144.
> 
> Are you cross-compiling?  The definition of kernel_ulong_t won't work on
> x86.

Yes, sorry, should have mentioned that. Build system is x86. Still,
it didn't happen before the recent acpi merge.

Jan
