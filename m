Return-Path: <linux-kernel-owner+w=401wt.eu-S1751303AbZGYEWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303AbZGYEWr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 00:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750940AbZGYEWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 00:22:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33709 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750817AbZGYEWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 00:22:46 -0400
Date: Fri, 24 Jul 2009 21:22:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
Subject: Re: [PATCH] sched: Provide iowait counters
Message-Id: <20090724212220.afa278ee.akpm@linux-foundation.org>
In-Reply-To: <4A64B813.1080506@linux.intel.com>
References: <4A64B813.1080506@linux.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jul 2009 11:31:47 -0700 Arjan van de Ven <arjan@linux.intel.com> wrote:

> For counting how long an application has been waiting for (disk) IO,
> there currently is only the HZ sample driven information available, while
> for all other counters in this class, a high resolution version is
> available via CONFIG_SCHEDSTATS.
> 
> In order to make an improved bootchart tool possible, we also need
> a higher resolution version of the iowait time.
> 
> This patch below adds this scheduler statistic to the kernel.

Doesn't this duplicate the delay accounting already available via the
taskstats interface?

