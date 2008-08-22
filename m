Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbYHVSwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbYHVSwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 14:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbYHVSwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 14:52:09 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:26132 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbYHVSwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 14:52:08 -0400
X-BigFish: VPS-19(zz98dR936eQ62a3Lzz10d3izzz32i6bh43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K60N2D-02-534-01
Date: Fri, 22 Aug 2008 20:51:34 +0200
From: Robert Richter <robert.richter@amd.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH] x86: fix: do not run code in amd_bus.c on non-AMD CPUs
Message-ID: <20080822185134.GA14103@erda.amd.com>
References: <48AD82D5.76E4.0078.0@novell.com> <1219429418-29023-1-git-send-email-robert.richter@amd.com> <86802c440808221147h4fb3c26cw31970678a100e2fc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <86802c440808221147h4fb3c26cw31970678a100e2fc@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 22 Aug 2008 18:51:56.0471 (UTC) FILETIME=[267F4C70:01C90488]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.08.08 11:47:45, Yinghai Lu wrote:
> 1. early_fill_mp_bus_info has checking with vendor/deviceid in itself.

Right, but scanning the pci bus could be skipped for non-AMD cpus. If
you don't like this check for your function I will resubmit a new
patch.

> 2. you didn't address: when cpu is hot plug in later,
> enable_pci_to_ecs_per_cpu will not be called.
> ( maxcpus and addtional_cpus)

Next patch?

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

