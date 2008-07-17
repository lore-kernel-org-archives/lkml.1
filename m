Return-Path: <linux-kernel-owner+w=401wt.eu-S1760143AbYGQRi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760143AbYGQRi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 13:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbYGQRit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 13:38:49 -0400
Received: from lizzard.sbs.de ([194.138.37.39]:21735 "EHLO lizzard.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692AbYGQRis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 13:38:48 -0400
X-Greylist: delayed 2923 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jul 2008 13:38:48 EDT
Message-ID: <487F7800.4010502@siemens.com>
Date: Thu, 17 Jul 2008 18:49:04 +0200
From: Jan Kiszka <jan.kiszka@SIEMENS.COM>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Avi Kivity <avi@qumranet.com>, kvm@vger.kernel.org,
       "Feng(Eric) Liu" <eric.e.liu@intel.com>
Subject: Re: [patch 4/4] KVM-trace port to tracepoints
References: <20080717155724.897537670@polymtl.ca> <20080717160003.359557938@polymtl.ca>
In-Reply-To: <20080717160003.359557938@polymtl.ca>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> Port/cleanup of KVM-trace to tracepoints.
> 
> Tracepoints allow dormat instrumentation, like the kernel markers, but also
> allows to describe the trace points in global headers so they can be easily
> managed. They also do not use format strings.
> 
> Anything that would involve an action (dereference a pointer, vmcs read, ...)
> only required when tracing is placed in the probes created in kvm_trace.c
> 
> This patch depends on the "Tracepoints" patch.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: 'Peter Zijlstra' <peterz@infradead.org>
> CC: 'Feng(Eric) Liu' <eric.e.liu@intel.com>
> CC: Avi Kivity <avi@qumranet.com>
> CC: kvm@vger.kernel.org
> ---
>  arch/x86/kvm/vmx.c   |   38 ++---
>  arch/x86/kvm/x86.c   |   43 ++----
>  include/trace/kvm.h  |   83 ++++++++++++
>  virt/kvm/kvm_trace.c |  336 +++++++++++++++++++++++++++++++++++++++++++--------
>  4 files changed, 398 insertions(+), 102 deletions(-)

Is it a specific property of KVM-trace that causes this LOC blow-up? Or
is this a generic side-effect of tracepoints?

[ Hmm, hope I didn't missed too much of the tracepoint discussion... ]

Jan

-- 
Siemens AG, Corporate Technology, CT SE 2
Corporate Competence Center Embedded Linux
