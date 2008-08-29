Return-Path: <linux-kernel-owner+w=401wt.eu-S1757278AbYH2AO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278AbYH2AO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 20:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbYH2AOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 20:14:49 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:41302 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbYH2AOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 20:14:48 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=0KDaXv3M4px4V551RJgA:9 a=N8W9LKASG3XwWKL5JL4A:7 a=7auLoWZoP4w33WftwTIwvw9TXBUA:4 a=1NJ_CfBzqpwA:10
Message-ID: <48B73F79.6040106@shaw.ca>
Date: Thu, 28 Aug 2008 18:14:49 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: stock@stokkie.net
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 
References: <0K6B0005EN54GNO0@l-daemon>
In-Reply-To: <0K6B0005EN54GNO0@l-daemon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stock@stokkie.net wrote:
>>> How about giving your sound device a proper seperate IRQ number?
>>> At least libata should like eth0 have its own kernel resources.
>> That's an issue with the way the motherboard IRQ lines are wired. 
>> There's nothing the kernel can do about it.
> 
> That sounds rather strange to me, as IRQ line 16 is a virtual
> IRQ as part of IO-APIC.

It's still generally wired that way on the motherboard, both devices are 
connected to the same IRQ line. Or at least, the kernel has no control 
over what devices are routed to what IRQs. It gets  the IRQ mapping from 
the BIOS and uses it.

> 
>> Normally I wouldn't expect that to make a big difference though..
> 
> fact is that when copying a iso from one SATA disk to the
> other results in flaky sound when playing online internet radio.
> Even starting firefox for the 1st time after booting results
> in flaky sound for a short time.
> 
>> You'd really have to try a newer kernel first in order to get much help, 
>> though. That's a pretty ancient kernel. Quite likely the situation is 
>> improved in newer versions.
> 
> I sure would like todo that. But why doesn't the linux-kernel community
> know howto pull virtual IRQ lines apart, as part of configuring
> a linux kernel? In the days of 386/486 cpu's, IRQ's of several
> add-on cards could be adjusted manually by jumpers. Why is there not
> such a thing for virtual IRQ's inside the IO-APIC system?
> 
> The libata driver should like eth0 on IRQ 19 have its own IRQ.

You'd have to take that up with your motherboard manufacturer, 
unfortunately :-)
