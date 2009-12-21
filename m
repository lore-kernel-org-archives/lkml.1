Return-Path: <linux-kernel-owner+w=401wt.eu-S1752767AbZLUNsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbZLUNsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 08:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbZLUNso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 08:48:44 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:55028 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618AbZLUNsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 08:48:42 -0500
Date: Mon, 21 Dec 2009 19:18:37 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: Re: [PATCH 6/7] implement utrace-ptrace
Message-ID: <20091221134837.GB12670@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20091218011140.GA29570@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091218011140.GA29570@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 02:11:40AM +0100, Oleg Nesterov wrote:
> The patch adds the new file, kernel/ptrace-utrace.c, which contains
> the new implementation of ptrace over utrace.
> 
> This file is not compiled until we have CONFIG_UTRACE option, will be
> added by the next "utrace core" patch.
> 
> It's supposed to be an invisible implementation change, nothing should
> change to userland when CONFIG_UTRACE is enabled.
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---

Oleg,

ptrace/utrace performs better with the ptrace-tests [1] testsuite (1 failure
vs. 3 with vanilla ptrace [1]). The gdb testsuite also has no
regressions. In fact, the results on the gdb testsuite are identical.

Ananth

[1] http://sourceware.org/systemtap/wiki/utrace/tests
[2] detach-stopped and stopped-attach-transparency are the additional
    failures. syscall-reset fails in both cases.

