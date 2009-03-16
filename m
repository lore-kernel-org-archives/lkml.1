Return-Path: <linux-kernel-owner+w=401wt.eu-S1760110AbZCPSLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760110AbZCPSLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 14:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbZCPSLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 14:11:35 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:43573 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbZCPSLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 14:11:35 -0400
Date: Mon, 16 Mar 2009 19:11:32 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: System tick rate
In-Reply-To: <1236934167.5188.195.camel@laptop>
Message-ID: <alpine.LSU.2.00.0903161911090.21735@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0903121435190.3835@fbirervta.pbzchgretzou.qr>  <20090312072110.0a325543@infradead.org>  <alpine.LSU.2.00.0903121541410.8068@fbirervta.pbzchgretzou.qr> <1236934167.5188.195.camel@laptop>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2009-03-13 09:49, Peter Zijlstra wrote:
>On Thu, 2009-03-12 at 15:45 +0100, Jan Engelhardt wrote:
>> On Thursday 2009-03-12 15:21, Arjan van de Ven wrote:
>> >On Thu, 12 Mar 2009 14:38:19 +0100 (CET) Jan Engelhardt wrote:
>> >> 
>> >> is there an "official" way of obtaining the current tick rate when 
>> >> CONFIG_NO_HZ? 
>> >
>> >what does "current tick rate" mean for you in a no-hz situation ?
>> >is it the HZ value (which is supposed to be invisible from userspace,
>> >so good luck) or the wakeup count ?
>> 
>> Hm, I guess what I want is the number of timer interrupts which
>> occurred within the observation period that called the scheduler
>> code. (So that excludes RTC on usual x86en.)
>
>There is no tick rate with NO_HZ mode, only a max tick rate, but as
>Arjan said, not even that is exposed to user-space.
>
>I think Dave's Niagra has the crown here, because he ran into some bug
>in the NO_HZ code some while back because he idled longer than we ever
>seen before. I think it was in the order of 30 minutes or something
>without a single wakeup of the CPU.
>
Well if it idled that long, it surely did not run any processes, did it?
