Return-Path: <linux-kernel-owner+w=401wt.eu-S1756249AbYHVTOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbYHVTOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 15:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbYHVTOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 15:14:16 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:37191 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbYHVTOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 15:14:15 -0400
X-BigFish: VPS-48(zz1432R98dR936eQ62a3L1805M936fQ9371P3b5bkzz10d3izzz32i6bh43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K60O37-02-5U7-01
Date: Fri, 22 Aug 2008 21:13:05 +0200
From: Robert Richter <robert.richter@amd.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH] x86: fix: do not run code in amd_bus.c on non-AMD CPUs
Message-ID: <20080822191304.GC14103@erda.amd.com>
References: <48AD82D5.76E4.0078.0@novell.com> <1219429418-29023-1-git-send-email-robert.richter@amd.com> <86802c440808221147h4fb3c26cw31970678a100e2fc@mail.gmail.com> <20080822185134.GA14103@erda.amd.com> <86802c440808221157v7578c984v571799763df5dab7@mail
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <86802c440808221157v7578c984v571799763df5dab7@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 22 Aug 2008 19:13:27.0600 (UTC) FILETIME=[2811F300:01C9048B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.08.08 11:57:39, Yinghai Lu wrote:
> On Fri, Aug 22, 2008 at 11:51 AM, Robert Richter <robert.richter@amd.com> wrote:
> > On 22.08.08 11:47:45, Yinghai Lu wrote:
> >> 1. early_fill_mp_bus_info has checking with vendor/deviceid in itself.
> >
> > Right, but scanning the pci bus could be skipped for non-AMD cpus. If
> > you don't like this check for your function I will resubmit a new
> > patch.
> 
> just fine, if you check vendor before that, we should remove check
> vendor again in later function.

Right. There are no more checks in, only the PCI vendor check that can
not be removed.

-Robert

> 
> YH
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

