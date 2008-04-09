Return-Path: <linux-kernel-owner+w=401wt.eu-S1758152AbYDIUKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152AbYDIUKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 16:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbYDIUKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 16:10:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325AbYDIUKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 16:10:46 -0400
Message-ID: <47FD2244.7010105@redhat.com>
Date: Wed, 09 Apr 2008 16:08:36 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net
Subject: Re: [patch 02/17] Kprobes - do not use kprobes mutex in arch code
References: <20080409150829.855195878@polymtl.ca> <20080409152047.133203801@polymtl.ca>
In-Reply-To: <20080409152047.133203801@polymtl.ca>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> Remove the kprobes mutex from kprobes.h, since it does not belong there. Also
> remove all use of this mutex in the architecture specific code, replacing it by
> a proper mutex lock/unlock in the architecture agnostic code.
> 
> Changelog :
> - remove unnecessary kprobe_mutex around arch_remove_kprobe()
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> CC: anil.s.keshavamurthy@intel.com
> CC: davem@davemloft.net

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

Thanks,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


