Return-Path: <linux-kernel-owner+w=401wt.eu-S1756873AbYA0O2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbYA0O2p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 09:28:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbYA0O2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 09:28:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbYA0O2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 09:28:36 -0500
Message-ID: <479C94F6.2070502@redhat.com>
Date: Sun, 27 Jan 2008 09:28:06 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Abhishek Sagar <sagar.abhishek@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, jkenisto@us.ibm.com,
       ananth@in.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] x86: WARN_ON breakpoints from .kprobes.text section
References: <479C4A4F.10604@gmail.com>
In-Reply-To: <479C4A4F.10604@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Abhishek,

Abhishek Sagar wrote:
> Identify breakpoints in .kprobes.text section. These certainly aren't kprobe 
> traps. However, we make an exception for the breakpoint hardcoded into jprobe_return.

Sorry, I can not understand what issue these patches can solve.
The breakpoint which is inserted by external debugger will be checked by
kprobe_handler() and be passed to other exception_notify_handlers.
In that case, we don't need to warn it.
I think current code is enough simple.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

