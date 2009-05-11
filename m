Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbZEKK36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbZEKK36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 06:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbZEKK3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 06:29:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:59675 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbZEKK3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 06:29:48 -0400
Subject: Re: [tip:perfcounters/core] perf_counter, x86: remove
 X86_FEATURE_ARCH_PERFMON flag for AMD cpus
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <20090511100226.GA31041@elte.hu>
References: <1241002046-8832-2-git-send-email-robert.richter@amd.com>
	 <tip-da1a776be1ac7f78bb30ececbec4c1383163b079@git.kernel.org>
	 <1241931753.4796.15.camel@localhost.localdomain>
	 <1241934795.4796.55.camel@localhost.localdomain>
	 <20090510063047.GD30778@elte.hu>
	 <1241938310.4796.67.camel@localhost.localdomain>
	 <20090511100226.GA31041@elte.hu>
Content-Type: text/plain
Date: Mon, 11 May 2009 15:57:32 +0530
Message-Id: <1242037652.3114.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-11 at 12:02 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > There is one more way to check performance monitor support for 
> > Intel by using IA32_MISC_ENABLE MSR (0x1A0) bit 7 tells whether 
> > performance monitoring is available or not.
> > 
> > But IA32_MISC_ENABLE MSR (0x1A0) is not available for Pentium and 
> > P6.
> > 
> > So better I will add new cpufeature for performance monitoring for 
> > x86:
> > 
> > X86_FEATURE_PERFMON : Performance monitor support
> 
> What is the exact wording of IA32_MISC_ENABLE bit 7 in the Intel 
> documents?
> 

Bit 7: Performance Monitoring Available. (R)
       1 = Performance monitoring enabled
       0 = Performance monitoring disabled

--
JSR


