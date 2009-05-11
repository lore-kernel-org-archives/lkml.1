Return-Path: <linux-kernel-owner+w=401wt.eu-S1756026AbZEKOfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026AbZEKOfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 10:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbZEKOf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:35:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40301 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbZEKOf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:35:26 -0400
Message-ID: <4A0837FC.9080006@redhat.com>
Date: Mon, 11 May 2009 10:36:44 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       Jim Keniston <jkenisto@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andi Kleen <ak@linux.intel.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH -tip v5 1/7] x86: instruction decorder API
References: <20090509004829.5505.38720.stgit@localhost.localdomain> <20090509004841.5505.48140.stgit@localhost.localdomain> <20090511092731.GA23875@infradead.org>
In-Reply-To: <20090511092731.GA23875@infradead.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Fri, May 08, 2009 at 08:48:42PM -0400, Masami Hiramatsu wrote:
>> Add x86 instruction decoder to arch-specific libraries. This decoder
>> can decode x86 instructions used in kernel into prefix, opcode, modrm,
>> sib, displacement and immediates. This can also show the length of
>> instructions.
> 
> Could also be used to implement a simple disasembler for OOPS output ala
> arch/s390/kernel/dis.c?

Yes, but as you may know, it's not so "simple"...especially show it as
"gas-like(a.k.a. at&t)" expression :-)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

