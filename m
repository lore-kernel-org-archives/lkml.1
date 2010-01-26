Return-Path: <linux-kernel-owner+w=401wt.eu-S1752378Ab0AZL3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378Ab0AZL3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 06:29:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913Ab0AZL3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 06:29:33 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:58660 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab0AZL3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 06:29:32 -0500
Date: Tue, 26 Jan 2010 12:29:29 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>, David Miller <davem@davemloft.net>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH v3] ftrace: unify arch_syscall_addr() implementations
Message-ID: <20100126112929.GA14135@osiris.boeblingen.de.ibm.com>
References: <1264230643-29434-1-git-send-email-vapier@gentoo.org>
 <1264498803-17278-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264498803-17278-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 04:40:03AM -0500, Mike Frysinger wrote:
> Most implementations of arch_syscall_addr() are the same, so create a
> default version in common code and move the one piece that differs (the
> syscall table) to asm/syscall.h.  New arch ports don't have to waste
> time copying & pasting this simple function.
> 
> The s390/sparc versions need to be different, so document why.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> Acked-by: David S. Miller <davem@davemloft.net>
> Acked-by: Paul Mundt <lethal@linux-sh.org>
> ---
> v3
> 	- move sys_call_table[] decl to asm/syscall.h
> 	- unify everyone's arch_syscall_addr() again
> 	- mention right tracehook requirements
> 
>  Documentation/trace/ftrace-design.txt |    5 ++---
>  arch/s390/include/asm/syscall.h       |    7 +++++++
>  arch/s390/kernel/ftrace.c             |   10 ----------

Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
