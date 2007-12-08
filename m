Return-Path: <linux-kernel-owner+w=401wt.eu-S1756660AbXLHAgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbXLHAgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 19:36:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbXLHAgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 19:36:32 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51416 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751941AbXLHAgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 19:36:31 -0500
Date: Fri, 7 Dec 2007 16:35:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: ananth@in.ibm.com
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, randy.dunlap@oracle.com,
       anil.s.keshavamurthy@intel.com, mathieu.desnoyers@polymtl.ca,
       davem@davemloft.net, prasanna@in.ibm.com
Subject: Re: [patch 1/2] Kprobes: Indicate kretprobe support in
 arch/<arch>/Kconfig
Message-Id: <20071207163504.9115b31f.akpm@linux-foundation.org>
In-Reply-To: <20071113154710.GB25095@in.ibm.com>
References: <20071021123919.GA7648@in.ibm.com>
	<20071113040045.0440e575.akpm@linux-foundation.org>
	<20071113153924.GA25095@in.ibm.com>
	<20071113154710.GB25095@in.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007 21:17:10 +0530
Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:

> From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> 
> This patch adds CONFIG_ARCH_SUPPORTS_KRETPROBES to the
> arch/<arch>/Kconfig file for relevant architectures with kprobes
> support. This facilitates easy handling of in-kernel modules (like
> samples/kprobes/kretprobe_example.c) that depend on kretprobes being
> present in the kernel.
> 
> This patch depends on Mathieu Desnoyers' "Instrumentation menu removal"
> patchset (http://marc.info/?l=linux-kernel&m=119496432229633&w=2)

I didn't merge this because I didn't merge Mathieu's patches because my brain
is not large enough to keep up with Mathieu's patches so sparc64 is still
busted.

Please send fixes against 2.6.24-rc4-mm1?

Thanks.
