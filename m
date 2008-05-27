Return-Path: <linux-kernel-owner+w=401wt.eu-S1758280AbYE0Qme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280AbYE0Qme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 12:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755718AbYE0Qm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 12:42:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37324 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbYE0Qm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 12:42:26 -0400
Date: Tue, 27 May 2008 09:40:35 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: svaidy@linux.vnet.ibm.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, venkatesh.pallipadi@intel.com,
       suresh.b.siddha@intel.com, Michael Neuling <mikey@neuling.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v1 0/3] Scaled statistics using APERF/MPERF in x86
Message-ID: <20080527094035.67ccda32@infradead.org>
In-Reply-To: <20080527140440.GD5181@dirshya.in.ibm.com>
References: <20080526142513.24680.97164.stgit@drishya.in.ibm.com>
	<20080526085000.33787eac@infradead.org>
	<20080527140440.GD5181@dirshya.in.ibm.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2008 19:34:40 +0530
Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
> 
> What we are proposing is a scaled time value that is scaled to the
> current CPU capacity.  If the scaled utilisation is 50% when the CPU
> is at 100% capacity, it is expected to remain at 50% even if the CPU's
> capacity is dropped to 50%, while the traditional utilisation value
> will be 100%.

When you use the word "capacity" I cringe ;(

> 
> The problem in the above two cases is that we had assumed that the
> maximum CPU capacity is 100% at normal capacity (without IDA).
> 
> If the CPU is at half the maximum frequency, then scaled stats should
> show 50%.  

see frequency != capacity.
It's about more than frequency. It's about how much cache you have
available too. If  you run single threaded on a dual core cpu, you have
100% of the cache, but the cpu is 50% idle. But that doesn't mean that
when you double the load, you actually get 2x the performance. So
you're not at 50% of capacity!



> The point I am trying to make is whether scaling should be done
> relative to CPUs designed maximum capacity or maximum capacity under
> current constraints is to be discussed.

now you're back at "capacity".. we were at frequency before ;(


> 
> Case A:
> ------
> 
> Scaled stats is stats relative to maximum designed capacity including
> IDA

you don't know what that is though.

