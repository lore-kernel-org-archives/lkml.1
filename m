Return-Path: <linux-kernel-owner+w=401wt.eu-S1753022AbZE3EH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbZE3EH3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 00:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750754AbZE3EHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 00:07:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750712AbZE3EHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 00:07:20 -0400
Date: Fri, 29 May 2009 21:07:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Diego Calleja <diegocg@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Performance regressions in 2.6.30-rc7?
Message-Id: <20090529210718.bef7a9c1.akpm@linux-foundation.org>
In-Reply-To: <200905282249.28592.diegocg@gmail.com>
References: <200905282249.28592.diegocg@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009 22:49:28 +0200 Diego Calleja <diegocg@gmail.com> wrote:

> Hi, phoronix.com has run some benchmarks in 2.6.30-rc7 [1], there're some
> good numbers, but there's also a couple of regressions. Some people think
> that phoronix benchmarks are not very serious/reliable/meaningful, but i
> thought it'd be better to post false warnings than letting real regressions
> slip in without notice.
> 
> The regressions would be:
> - 7zip MIPS ("7zr b" command) http://www.phoronix.com/data/img/results/linux_2630/1.png
> 
> - tiobench latency (not throughput) using 64MB writes with 32 threads
> http://www.phoronix.com/data/img/results/linux_2630/7.png
> 
> -gnupg 2GB file encryption http://www.phoronix.com/data/img/results/linux_2630/3.png
> 
> 
> Full article: http://www.phoronix.com/scan.php?page=article&item=linux_2630

Those regressions are huge.  They appear to be on compute-intensive
workloads too.

I wonder if some expensive debugging option turned itself on or
something silly like that.

