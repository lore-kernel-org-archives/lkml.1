Return-Path: <linux-kernel-owner+w=401wt.eu-S1762317AbYA2ARt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762317AbYA2ARt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 19:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763628AbYA2ARf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 19:17:35 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:17701 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763572AbYA2ARe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 19:17:34 -0500
Date: Mon, 28 Jan 2008 18:19:17 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Problem with ata layer in 2.6.24
In-reply-to: <fa.ebGd1717PgKMzHUmaQOLoLkFdsI@ifi.uio.no>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Mark Lord <liml@rtr.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <479E7105.2090201@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.YoSRdik0niRWE1jgfb9yTQPim5A@ifi.uio.no>
 <fa.fCSKKy5aVmh9IomaWmc+Y8P16+c@ifi.uio.no>
 <fa.ebGd1717PgKMzHUmaQOLoLkFdsI@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> And so far no one has tried to comment on those 2 dmesg lines I've quoted a 
> couple of times now, here's another:
> [    0.000000] Nvidia board detected. Ignoring ACPI timer override.
> [    0.000000] If you got timer trouble try acpi_use_timer_override
> what the heck is that trying to tell me to do, in some sort of broken english?

A lot of NVIDIA-chipset motherboards have BIOS problems where they 
include an incorrect ACPI interrupt override for the timer interrupt, 
which tends to cause the system to fail to boot due to the timer 
interrupt not working. The kernel normally ignores ACPI interrupt 
overrides on the timer interrupt for NVIDIA chipsets for this reason. 
Unfortunately on some such boards the override is actually correct and 
needed, and so this actually causes problems. Hence the 
acpi_use_timer_override option.

In any case this is unlikely to have anything to do with your problem, 
since if that was messed up you likely would never have even booted.
