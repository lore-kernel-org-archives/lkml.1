Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbYG3T3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbYG3T3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 15:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbYG3T3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 15:29:08 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:41828 "EHLO
	pd5mo1no-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754046AbYG3T3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 15:29:06 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=UPpEl9ePzhy9p6dRbtwA:9 a=gVxXhnTwBZ-nnuZIMNS1d4TgonsA:4
Message-ID: <4890C0FC.7010604@shaw.ca>
Date: Wed, 30 Jul 2008 13:29:00 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Dimitri Sivanich <sivanich@sgi.com>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: CONFIG_HOTPLUG_CPU on x86
References: <fa.NXaOVSU/kxtRXoZokQC2Y0/po4M@ifi.uio.no>
In-Reply-To: <fa.NXaOVSU/kxtRXoZokQC2Y0/po4M@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dimitri Sivanich wrote:
> I've heard folks say that hotplug cpu is very reliable.  I'm assuming
> that's in the context of the x86 architecture.  If so, how come
> CONFIG_HOTPLUG_CPU is still listed as EXPERIMENTAL in arch/x86/Kconfig?
> Should this be changed for the x86 architecture?
> 
> config HOTPLUG_CPU
> 	bool "Support for suspend on SMP and hot-pluggable CPUs (EXPERIMENTAL)"
> 	depends on SMP && HOTPLUG && EXPERIMENTAL && !X86_VOYAGER

Yes, it's a bit bizarre that something needed for suspending almost any 
current laptop is still marked as "experimental"..
