Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbZBDKqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbZBDKqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 05:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbZBDKqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 05:46:08 -0500
Received: from ozlabs.org ([203.10.76.45]:54214 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbZBDKqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 05:46:05 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + work_on_cpu-rewrite-it-to-create-a-kernel-thread-on-demand.patch  added to -mm tree
Date: Wed, 4 Feb 2009 21:16:00 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: =?iso-8859-1?q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       mingo@elte.hu, linux-kernel@vger.kernel.org, oleg@redhat.com,
       travis@sgi.com, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org
References: <200902031058.n13AwOoK016719@imap1.linux-foundation.org> <200902041428.12059.rusty@rustcorp.com.au> <20090203201642.057a07b9.akpm@linux-foundation.org>
In-Reply-To: <20090203201642.057a07b9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902042116.01609.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009 14:46:42 Andrew Morton wrote:
> These:
> 
> int rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
> int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
> int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
> int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
> 
> already exist.  I don't think anything else needs to be done here?

Nope.  Well, it'd be nice if they just used a u64, but we can't fix the whole
kernel.

Thanks!
Rusty.
