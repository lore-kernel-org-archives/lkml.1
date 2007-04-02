Return-Path: <linux-kernel-owner+w=401wt.eu-S1751642AbXDBQOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642AbXDBQOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 12:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbXDBQOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 12:14:36 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:54326 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751642AbXDBQOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 12:14:35 -0400
Date: Mon, 2 Apr 2007 12:14:43 -0400
To: Stephane Eranian <eranian@hpl.hp.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       perfmon@napali.hpl.hp.com
Subject: Re: exposing FSB clock speed in /sys
Message-ID: <20070402161443.GD3510@csclub.uwaterloo.ca>
References: <20070330153937.GC16059@frankl.hpl.hp.com> <p73bqiaqh32.fsf@bingen.suse.de> <20070331081832.GB17535@frankl.hpl.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070331081832.GB17535@frankl.hpl.hp.com>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2007 at 12:18:32AM -0800, Stephane Eranian wrote:
> Well, I am talking about the bus that connects the processor socket to the
> chipset on Intel machines. On Intel Core 2 Duo (aka Woodcrest), you have 
> 2 sockets, thus two buses connecting to the chipset which then connects
> to the memory (among other things).
> 
> The Woodcrest (Intel Core PMU) is capable of measuring the number of bus
> transactions to memory (look at the BUS_* events). You can count per core
> or for the entire socket (both cores). In order to know if you saturate
> the bus (from socket to chipset), you need to know the theoretical peak
> number of transactions the bus can sustain. For that you need to bus
> frequency. 
> 
> I am not interested in older processors, but I think for all recent Intel
> processors, there is a fairly simple algorithm to get the frequency using
> a couple of MSRs (including MSR_IA32_EBL_CR_POWERON or MSR_FSB_FREQ).
> 
> Don't we already have /sys entries that exits only for certain processors
> or platforms?
> 
> I think the Opteron have HYPERTRANSPORT-related events which could be used
> to obtain similar metrics.
> 
> Knowledge of bus saturation is important for multi-core programming.

How about the speed between ram and the chipset?  Is it single or dual
channel?  Are there PCI devices currently doing DMA transfers to ram
taking up bandwidth?  What are the latencies of the ram, Etc, etc, etc.

And what could your software do differently if it knew this information?

--
Len Sorensen
