Return-Path: <linux-kernel-owner+w=401wt.eu-S1759979AbYEACZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759979AbYEACZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 22:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbYEACZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 22:25:40 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:21632 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbYEACZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 22:25:39 -0400
Date: Wed, 30 Apr 2008 20:25:28 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: APIC error 80(80) and 00(80)
In-reply-to: <fa.eZiCdv20DPnWq2lstvMQhP+yqtg@ifi.uio.no>
To: Timur Alperovich <timur.alperovich@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <48192A18.2080502@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.eZiCdv20DPnWq2lstvMQhP+yqtg@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timur Alperovich wrote:
> Hi,
> 
> I apologize if others have asked this question before, but I'm a bit
> confused by the APIC error messages, i.e. I couldn't find what they
> mean. After inserting a kernel module I wrote and trying to read the
> device it created, I see the following in dmesg:
> 
> Losing some ticks... checking if CPU frequency changed.
> warning: many lost ticks.
> Your time source seems to be instable or some driver is hogging interupts
> rip tg3_read32+0x9/0xa [tg3]
> Falling back to HPET
> APIC error on CPU3: 00(80)
> APIC error on CPU3: 80(80)
> 
> where the last message was repeated 1600 times. Could anyone tell me
> what it means or of a better place to ask about it?

Not sure exactly what that means, but sounds like something really wonky 
happened.. I'd suspect your code somehow got stuck in a loop with 
interrupts off on one CPU, or corrupted memory, or something.
