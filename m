Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbXLHPQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbXLHPQo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 10:16:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbXLHPQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 10:16:36 -0500
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:54837 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751473AbXLHPQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 10:16:35 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArgeANNCWkdMROHU/2dsb2JhbACBWoFL
Date: Sat, 8 Dec 2007 10:16:33 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ananth@in.ibm.com, linux-kernel@vger.kernel.org, hch@infradead.org,
       randy.dunlap@oracle.com, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net, prasanna@in.ibm.com
Subject: Re: [patch 1/2] Kprobes: Indicate kretprobe support in
	arch/<arch>/Kconfig
Message-ID: <20071208151633.GA22007@Krystal>
References: <20071021123919.GA7648@in.ibm.com> <20071113040045.0440e575.akpm@linux-foundation.org> <20071113153924.GA25095@in.ibm.com> <20071113154710.GB25095@in.ibm.com> <20071207163504.9115b31f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071207163504.9115b31f.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:16:03 up 34 days, 20:21,  3 users,  load average: 0.42, 0.46,
	0.72
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Tue, 13 Nov 2007 21:17:10 +0530
> Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:
> 
> > From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> > 
> > This patch adds CONFIG_ARCH_SUPPORTS_KRETPROBES to the
> > arch/<arch>/Kconfig file for relevant architectures with kprobes
> > support. This facilitates easy handling of in-kernel modules (like
> > samples/kprobes/kretprobe_example.c) that depend on kretprobes being
> > present in the kernel.
> > 
> > This patch depends on Mathieu Desnoyers' "Instrumentation menu removal"
> > patchset (http://marc.info/?l=linux-kernel&m=119496432229633&w=2)
> 
> I didn't merge this because I didn't merge Mathieu's patches because my brain
> is not large enough to keep up with Mathieu's patches so sparc64 is still
> busted.
> 
> Please send fixes against 2.6.24-rc4-mm1?
> 
> Thanks.

I'll resend the instrumentation menu removal patchset against
2.6.24-rc4-mm1 immediately.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
