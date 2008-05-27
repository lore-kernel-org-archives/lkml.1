Return-Path: <linux-kernel-owner+w=401wt.eu-S1758011AbYE0Pft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011AbYE0Pft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 11:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757906AbYE0PfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 11:35:20 -0400
Received: from www.tglx.de ([62.245.132.106]:54838 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757209AbYE0PfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 11:35:18 -0400
Date: Tue, 27 May 2008 17:34:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, pq@iki.fi,
       proski@gnu.org, sandmann@redhat.com, a.p.zijlstra@chello.nl,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/5] ftrace: limit use of check pages
In-Reply-To: <20080522042301.622087604@goodmis.org>
Message-ID: <alpine.LFD.1.10.0805271733120.3295@apollo.tec.linutronix.de>
References: <20080522042215.584408893@goodmis.org> <20080522042301.622087604@goodmis.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008, Steven Rostedt wrote:

> The check_pages function is called often enough that it can cause problems
> with trace outputs or even bringing the system to a halt.
> 
> This patch limits the check_pages to the places that are most likely to
> have problems. The check is made at the flip between the global array and
> the max save array, as well as when the size of the buffers changes and
> the self tests.
> 
> This patch also removes the BUG_ON from check_pages and replaces it with
> a WARN_ON and disabling of the tracer.

Applied and fixed the typo.
 
> +		tracing_disabled = 0;		\

Thanks,
	tglx
