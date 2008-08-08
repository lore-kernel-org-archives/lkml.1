Return-Path: <linux-kernel-owner+w=401wt.eu-S1757284AbYHHR1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbYHHR1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 13:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbYHHR1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 13:27:00 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:3734 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbYHHR07 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 13:26:59 -0400
X-BigFish: VPS-12(zz1432R1805Mzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K5ALSG-01-FWN-01
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH -next] powernow-k8: fix build errors
Date: Fri, 8 Aug 2008 12:26:48 -0500
Message-ID: <6453C3CB8E2B3646B0D020C112613273C5AC58@sausexmb4.amd.com>
In-Reply-To: <20080808101950.7a942fa6.randy.dunlap@oracle.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH -next] powernow-k8: fix build errors
Thread-Index: Acj5e3PJ6TM8e30wShCxkZUNsdaxsQAAGzVg
References: <20080808101950.7a942fa6.randy.dunlap@oracle.com>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "lkml" <linux-kernel@vger.kernel.org>
CC: <davej@codemonkey.org.uk>, "akpm" <akpm@linux-foundation.org>
X-OriginalArrivalTime: 08 Aug 2008 17:26:49.0986 (UTC) FILETIME=[F1030620:01C8F97B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix build when CONFIG_X86_POWERNOW_K8_ACPI=n:
> (seems that someone forgot to test this build combo)
> (fix 25 of 50 randconfig build errors)
> 
> linux-next-20080808/arch/x86/kernel/cpu/cpufreq/powernow-k8.c:
> 1334: error: implicit declaration of function 
> 'powernow_k8_cpu_preinit_acpi'
> linux-next-20080808/arch/x86/kernel/cpu/cpufreq/powernow-k8.c:
> 1352: error: 'acpi_perf_data' undeclared (first use in this function)
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Ack, thanks.

-Mark Langsdorf
Operating System Research Center
AMD

