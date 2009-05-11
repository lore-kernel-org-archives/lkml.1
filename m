Return-Path: <linux-kernel-owner+w=401wt.eu-S1757890AbZEKJ1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890AbZEKJ1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 05:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755961AbZEKJ1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 05:27:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41297 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756986AbZEKJ1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 05:27:43 -0400
Date: Mon, 11 May 2009 05:27:32 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       Jim Keniston <jkenisto@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andi Kleen <ak@linux.intel.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH -tip v5 1/7] x86: instruction decorder API
Message-ID: <20090511092731.GA23875@infradead.org>
References: <20090509004829.5505.38720.stgit@localhost.localdomain> <20090509004841.5505.48140.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090509004841.5505.48140.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 08:48:42PM -0400, Masami Hiramatsu wrote:
> Add x86 instruction decoder to arch-specific libraries. This decoder
> can decode x86 instructions used in kernel into prefix, opcode, modrm,
> sib, displacement and immediates. This can also show the length of
> instructions.

Could also be used to implement a simple disasembler for OOPS output ala
arch/s390/kernel/dis.c?

