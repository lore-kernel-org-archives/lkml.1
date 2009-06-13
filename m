Return-Path: <linux-kernel-owner+w=401wt.eu-S1752720AbZFMDoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbZFMDoN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 23:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbZFMDoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 23:44:01 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:45650 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbZFMDoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 23:44:01 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18995.8319.322002.917595@cargo.ozlabs.ibm.com>
Date: Sat, 13 Jun 2009 13:43:59 +1000
From: Paul Mackerras <paulus@samba.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: perf_counters: page fault trace record
In-Reply-To: <4A330022.3070105@linux.vnet.ibm.com>
References: <4A330022.3070105@linux.vnet.ibm.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corey Ashford writes:

> One of the tools we are working on needs to be able to look not only at counts 
> of page faults, but where they are occurring (ip and faulting page address).
> 
> What would you think about adding a new bit to the config record, something like:

Can't you do what you need just using a page fault software counter
with sample_type = PERF_SAMPLE_IP | PERF_SAMPLE_ADDR and
sample_period = 1?

Paul.
