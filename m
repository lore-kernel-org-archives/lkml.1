Return-Path: <linux-kernel-owner+w=401wt.eu-S1762149AbYCUWly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762149AbYCUWly (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756259AbYCUWlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:41:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756118AbYCUWlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:41:45 -0400
Date: Fri, 21 Mar 2008 15:41:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: cpufreq@lists.linux.org.uk, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com
Subject: Re: [PATCH] cpufreq: Expose cpufreq coordination requirements
 regardless of coordination mechanism
Message-Id: <20080321154124.668969a2.akpm@linux-foundation.org>
In-Reply-To: <20080321004354.GQ5529@tree.beaverton.ibm.com>
References: <20080321004354.GQ5529@tree.beaverton.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2008 17:43:54 -0700
"Darrick J. Wong" <djwong@us.ibm.com> wrote:

> Currently, affected_cpus shows which CPUs need to have their frequency
> coordinated in software.  When hardware coordination is in use, the
> contents of this file appear the same as when no coordination is
> required.  This can lead to some confusion among user-space programs,
> for example, that do not know that extra coordination is required to
> force a CPU core to a particular speed to control power consumption.
> 
> To fix this, create a "related_cpus" attribute that always displays
> the coordination map regardless of whatever coordination strategy
> the cpufreq driver uses (sw or hw).  If the cpufreq driver does not
> provide a value, fall back to policy->cpus.

I was going to ding you for not updating the kernel->userspace API
documentation.  But it seems that none of this interface is documented
anyway :(
