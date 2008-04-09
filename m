Return-Path: <linux-kernel-owner+w=401wt.eu-S1757763AbYDIUJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763AbYDIUJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 16:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbYDIUJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 16:09:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753710AbYDIUJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 16:09:44 -0400
Message-ID: <47FD222C.1070301@redhat.com>
Date: Wed, 09 Apr 2008 16:08:12 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>, hch@infradead.org,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net
Subject: Re: [patch 01/17] Kprobes - use a mutex to protect the instruction
 pages list.
References: <20080409150829.855195878@polymtl.ca> <20080409152046.801193890@polymtl.ca>
In-Reply-To: <20080409152046.801193890@polymtl.ca>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> Protect the instruction pages list by a specific insn pages mutex, called in 
> get_insn_slot() and free_insn_slot(). It makes sure that architectures that does
> not need to call arch_remove_kprobe() does not take an unneeded kprobes mutex.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> CC: hch@infradead.org
> CC: anil.s.keshavamurthy@intel.com
> CC: davem@davemloft.net

These kprobes related patches are good to me.

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

Thank you!

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


