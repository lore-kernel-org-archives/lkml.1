Return-Path: <linux-kernel-owner+w=401wt.eu-S1761366AbXIVKBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761366AbXIVKBZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 06:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbXIVKBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 06:01:18 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:37452 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbXIVKBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 06:01:17 -0400
Date: Sat, 22 Sep 2007 12:01:16 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Satyam Sharma <satyam@infradead.org>
cc: Andi Kleen <ak@suse.de>, patches@x86-64.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [34/50] i386: Fix argument signedness warnings
In-Reply-To: <alpine.LFD.0.999.0709221029170.19812@enigma.security.iitk.ac.in>
Message-ID: <Pine.LNX.4.64.0709221200210.15712@fbirervta.pbzchgretzou.qr>
References: <200709221231.836138000@suse.de> <20070921223234.0A71513DCD@wotan.suse.de>
 <alpine.LFD.0.999.0709221029170.19812@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 22 2007 10:36, Satyam Sharma wrote:
>> from arch/i386/boot/compressed/misc.c:14:
>> include/asm/processor.h: In function ‘cpuid_count’:
>                                       ^^^^^^^^^^           ^^^^^^^^^^
>> include/asm/processor.h:615: warning: pointer targets in passing
>> argument 1 of ‘native_cpuid’ differ in signedness
>
>> include/asm/processor.h:615: warning: pointer targets in passing
>> argument 2 of ‘native_cpuid’ differ in signedness
>
>> include/asm/processor.h:615: warning: pointer targets in passing
>> argument 3 of ‘native_cpuid’ differ in signedness
>
>> include/asm/processor.h:615: warning: pointer targets in passing
>> argument 4 of ‘native_cpuid’ differ in signedness
>                ^^^^^^^^^^            ^^^^^^^^^^
>
>Yikes. My bad, I had faulty (default) alpine settings (and a sad
>combination of LANG=en_US.UTF-8) when I made and sent out that patch.
>Please ensure that this finally gets committed in a somewhat saner and
>more readable state to the tree.

I am not too thrilled about gcc using non-ascii for interpunctuation
(for Western languages)..
