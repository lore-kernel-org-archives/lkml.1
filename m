Return-Path: <linux-kernel-owner+w=401wt.eu-S1762280AbYAQWx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762280AbYAQWx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:53:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760280AbYAQWoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:44:16 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:49040 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760975AbYAQWoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:44:14 -0500
Date: Thu, 17 Jan 2008 23:44:13 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Michael Opdenacker <michael-lists@free-electrons.com>
cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       Linux-tiny@selenic.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: fix unconditional arch/x86/kernel/pcspeaker.c
 compiling
In-Reply-To: <478F8AEC.1080209@free-electrons.com>
Message-ID: <Pine.LNX.4.64.0801172342230.18447@fbirervta.pbzchgretzou.qr>
References: <200801171643.49301.michael-lists@free-electrons.com>
 <1200587774.5332.11.camel@cinder.waste.org> <478F8AEC.1080209@free-electrons.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 17 2008 18:05, Michael Opdenacker wrote:
>>> +ifeq ($(CONFIG_INPUT_PCSPKR),y)
>>> +	obj-y			+= pcspeaker.o
>>> +endif
>>>     
>>
>> I'm not sure this does what you want. What if CONFIG_INPUT_PCSPKR = m?
>>   
>Does it make sense to compile arch/x86/kernel/pcspeaker.c as a module?

Hardly. No. Absolutely not. pcspeaker.c is a mere 20 lines - when
compiled (on x86_64) a mere 1824 bytes (and most of that is probably
ELF overhead). If you build that as a module, be sure to add an extra
6 to 7 kilobyte as module overhead. No, this is not really worth it.
