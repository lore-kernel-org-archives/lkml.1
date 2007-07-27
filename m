Return-Path: <linux-kernel-owner+w=401wt.eu-S1763086AbXG0AQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763086AbXG0AQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 20:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbXG0AQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 20:16:18 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49111 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752567AbXG0AQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 20:16:17 -0400
Date: Thu, 26 Jul 2007 17:16:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fenghua Yu <fenghua.yu@intel.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       venkatesh.pallipadi@intel.com
Subject: Re: [PATCH] Fix uninitialized local variable "covered" in i386
 acpi-cpufreq driver
Message-Id: <20070726171608.474eaf82.akpm@linux-foundation.org>
In-Reply-To: <20070726171222.4459155a.akpm@linux-foundation.org>
References: <1181754124.6148.37.camel@localhost>
	<20070726234630.GA29288@linux-os.sc.intel.com>
	<20070726171222.4459155a.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007 17:12:22 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> How's that for a one-liner? ;)

- the return value from acpi_cpufreq_early_init() gets ignored,
  so the module will still load, but won't work.

- Once that is fixed, the test for !acpi_perf_data[cpu] in
  acpi_cpufreq_cpu_init() can be removed.


