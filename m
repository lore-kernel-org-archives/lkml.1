Return-Path: <linux-kernel-owner+w=401wt.eu-S1753833AbYAQPMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbYAQPMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 10:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbYAQPMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 10:12:24 -0500
Received: from gate.crashing.org ([63.228.1.57]:37344 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbYAQPMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 10:12:24 -0500
Cc: wim@iguana.be, Scott Wood <scottwood@freescale.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Message-Id: <9E91DB29-BBB8-4CC9-8F6D-71306329D7A5@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Jochen Friedrich <jochen@scram.de>
In-Reply-To: <478F6C5F.4010505@scram.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: [PATCH/RFCv2] wdt: Add support for PowerQUICC watchdog
Date: Thu, 17 Jan 2008 09:11:57 -0600
References: <478F4E4A.4060907@scram.de> <A00FB5AE-903B-461A-B234-4BA817B3C5CB@kernel.crashing.org> <478F6C5F.4010505@scram.de>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 17, 2008, at 8:55 AM, Jochen Friedrich wrote:

> Hi Kumar,
>
>> Why are you commenting on mpc83xx_wdt with respect to pq1_wdt?
>> Also, is this driver just for PQ1 platforms or PQ1 & PQ2?  If its  
>> just pq1 we should probably call it pq1_wdt*
>
> It should be for pq1, pq2 and pq2pro. However, i only have the  
> possibility
> to test this on pq1.
>
>>> arch/powerpc/platforms/8xx/mpc86xads_setup.c |    5 +
>>> arch/powerpc/platforms/8xx/mpc885ads_setup.c |    5 +
>>> arch/powerpc/sysdev/Makefile                 |    3 +
>>> arch/powerpc/sysdev/pq_wdt.c                 |  203 +++++++++++++++ 
>>> ++++++++
>>> arch/powerpc/sysdev/pq_wdt.h                 |   28 ++++
>>> drivers/watchdog/Kconfig                     |   13 ++-
>>> drivers/watchdog/Makefile                    |    1 +
>>> drivers/watchdog/pq_wdt.c                    |  225 +++++++++++++++ 
>>> +++++++++++
>>> 8 files changed, 482 insertions(+), 1 deletions(-)
>>> create mode 100644 arch/powerpc/sysdev/pq_wdt.c
>>> create mode 100644 arch/powerpc/sysdev/pq_wdt.h
>>> create mode 100644 drivers/watchdog/pq_wdt.c
>> What are the bits in sysdev/pq_wdt.{c,h}.  Why aren't these just in  
>> drivers/watchdog?
>
> These are the parts needed to boot a device with activated watchdog.  
> If a bootloader like u-boot activates the watchdog, it can't be  
> deactivated again
> and needs to be reset at regular intervals. This is done using a  
> kernel timer.
> The driver in drivers/watchdog disables the timer as soon as the wdt  
> device
> is opened.

Ok, but is there a need for these bits to be in sysdev vs just being  
in the driver and calling into it.

- k
