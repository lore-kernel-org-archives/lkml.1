Return-Path: <linux-kernel-owner+w=401wt.eu-S932868AbXHFO2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868AbXHFO2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 10:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932144AbXHFO2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 10:28:44 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:42293 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762820AbXHFO2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 10:28:43 -0400
Date: Mon, 6 Aug 2007 16:28:42 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Chris Snook <csnook@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Few interrupts with NO_HZ
In-Reply-To: <46B72688.8070303@redhat.com>
Message-ID: <Pine.LNX.4.64.0708061626010.13469@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0708061247150.13469@fbirervta.pbzchgretzou.qr>
 <46B72688.8070303@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 6 2007 09:47, Chris Snook wrote:
>> 
>> this more of an informational question. So:
>> kernel version is 2.6.22.1 on i686
>> /proc/uptime 9917.81 9140.90 (2h45m)
>> /proc/cpuinfo:
>>            CPU0
>>   0:        282   IO-APIC-edge      timer
>> 
>> this is kinda neat, I expected much more interrupts than just 282
>> since boot. What kernel code actually uses the irq0 timer?
>
> If you don't have an HPET (and most single-processor systems do not)

This is an AMD Athlon with 'Thoroughbred' core; it does not seem to
have C-states at all (or: exactly one). It clearly is not idle all the
time, sometimes I run povray. (And 282 has not changed since the
morning.)


	Jan
-- 
