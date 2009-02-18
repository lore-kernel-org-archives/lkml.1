Return-Path: <linux-kernel-owner+w=401wt.eu-S1754392AbZBRMJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbZBRMJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 07:09:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbZBRMH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 07:07:26 -0500
Received: from casper.infradead.org ([85.118.1.10]:57238 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860AbZBRMHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 07:07:24 -0500
Subject: Re: [PATCH] perfcounters: allow sysadmin to restrict non-root
 counting of kernel events
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <18843.57965.710475.395466@cargo.ozlabs.ibm.com>
References: <18843.57965.710475.395466@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Wed, 18 Feb 2009 13:07:20 +0100
Message-Id: <1234958840.4637.61.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-18 at 21:26 +1100, Paul Mackerras wrote:
> Impact: security feature
> 
> This allows the sysadmin to prevent non-root users from counting
> hardware events that occur in kernel or hypervisor mode via a sysfs file:
> 
> 	/sys/devices/system/cpu/perf_counters/restrict_kernel_events
> 
> This defaults to off (0), allowing users to count kernel and hypervisor
> events, but if the sysadmin writes 1 to that file, any new counters
> created by non-root users will automatically be set to ignore kernel
> and hypervisor events.
> 
> This could be useful if there is a concern that allowing non-root users
> to count kernel or hypervisor events might leak sensitive information.

I would expect it the other way around, don't allow users access to
kernel/hv events unless explicitly granted.

