Return-Path: <linux-kernel-owner+w=401wt.eu-S1755594AbYG3Th3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbYG3Th3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 15:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbYG3ThV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 15:37:21 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5626 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbYG3ThU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 15:37:20 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5349"; a="5015678"
Message-ID: <4890C2FF.2030709@qualcomm.com>
Date: Wed, 30 Jul 2008 12:37:35 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Dimitri Sivanich <sivanich@sgi.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: CONFIG_HOTPLUG_CPU on x86
References: <fa.NXaOVSU/kxtRXoZokQC2Y0/po4M@ifi.uio.no> <4890C0FC.7010604@shaw.ca>
In-Reply-To: <4890C0FC.7010604@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Robert Hancock wrote:
> Dimitri Sivanich wrote:
>> I've heard folks say that hotplug cpu is very reliable.  I'm assuming
>> that's in the context of the x86 architecture.  If so, how come
>> CONFIG_HOTPLUG_CPU is still listed as EXPERIMENTAL in arch/x86/Kconfig?
>> Should this be changed for the x86 architecture?
>>
>> config HOTPLUG_CPU
>>     bool "Support for suspend on SMP and hot-pluggable CPUs
>> (EXPERIMENTAL)"
>>     depends on SMP && HOTPLUG && EXPERIMENTAL && !X86_VOYAGER
> 
> Yes, it's a bit bizarre that something needed for suspending almost any
> current laptop is still marked as "experimental"..

Why don't use guys just submit a patch that removes EXPERIMENTAL thing.

Max
