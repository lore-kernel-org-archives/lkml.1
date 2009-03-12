Return-Path: <linux-kernel-owner+w=401wt.eu-S1756326AbZCLOqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326AbZCLOqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 10:46:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755990AbZCLOpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 10:45:51 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:42148 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbZCLOpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 10:45:49 -0400
Date: Thu, 12 Mar 2009 15:45:46 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Arjan van de Ven <arjan@infradead.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: System tick rate
In-Reply-To: <20090312072110.0a325543@infradead.org>
Message-ID: <alpine.LSU.2.00.0903121541410.8068@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0903121435190.3835@fbirervta.pbzchgretzou.qr> <20090312072110.0a325543@infradead.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2009-03-12 15:21, Arjan van de Ven wrote:
>On Thu, 12 Mar 2009 14:38:19 +0100 (CET) Jan Engelhardt wrote:
>> 
>> is there an "official" way of obtaining the current tick rate when 
>> CONFIG_NO_HZ? 
>
>what does "current tick rate" mean for you in a no-hz situation ?
>is it the HZ value (which is supposed to be invisible from userspace,
>so good luck) or the wakeup count ?

Hm, I guess what I want is the number of timer interrupts which
occurred within the observation period that called the scheduler
code. (So that excludes RTC on usual x86en.)
