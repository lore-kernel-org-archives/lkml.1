Return-Path: <linux-kernel-owner+w=401wt.eu-S1756063AbXJKFR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbXJKFR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 01:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbXJKFRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 01:17:18 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39514 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752878AbXJKFRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 01:17:17 -0400
Date: Wed, 10 Oct 2007 22:17:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: mgross@linux.intel.com
Cc: arjan@infradead.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, linux-pm@lists.linux-foundation.org,
       mark.gross@intel.com
Subject: Re: pm qos infrastructure and interface
Message-Id: <20071010221704.6e438c71.akpm@linux-foundation.org>
In-Reply-To: <20071004215139.GA20078@linux.intel.com>
References: <20071004215139.GA20078@linux.intel.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Oct 2007 14:51:39 -0700 Mark Gross <mgross@linux.intel.com> wrote:

> The following patch is a generalization of the latency.c implementation
> done by Arjan last year.  It provides infrastructure for more than one
> parameter, and exposes a user mode interface for processes to register
> pm_qos expectations of processes.
> 
> 
> This interface provides a kernel and user mode interface for registering
> performance expectations by drivers, subsystems and user space
> applications on one of the parameters.
> 
> Currently we have {cpu_dma_latency, network_latency, network_throughput}
> as the initial set of pm_qos parameters.
> 
> The infrastructure exposes multiple misc device nodes one per
> implemented parameter.  The set of parameters implement is defined by
> pm_qos_power_init() and pm_qos_params.h.  This is done because having
> the available parameters being runtime configurable or changeable from a
> driver was seen as too easy to abuse.

I'm a bit surprised that this change appears to have no configurability.
If one has set CONFIG_PM=n (for example), shouldn't it all go away?
