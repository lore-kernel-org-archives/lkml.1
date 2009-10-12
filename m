Return-Path: <linux-kernel-owner+w=401wt.eu-S1758465AbZJLVcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758465AbZJLVcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758370AbZJLVcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:32:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836AbZJLVcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:32:18 -0400
Message-ID: <4AD3A13D.2090906@redhat.com>
Date: Mon, 12 Oct 2009 17:35:57 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net, ananth@in.ibm.com,
       tglx@linutronix.de, mhiramat@redhat.com
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/cleanups] x86: use kernel_stack_pointer() in kprobes.c
References: <tip-98272ed0d2e6509fe7dc571e77956c99bf653bb6@git.kernel.org>
In-Reply-To: <tip-98272ed0d2e6509fe7dc571e77956c99bf653bb6@git.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tip-bot for H. Peter Anvin wrote:
> Commit-ID:  98272ed0d2e6509fe7dc571e77956c99bf653bb6
> Gitweb:     http://git.kernel.org/tip/98272ed0d2e6509fe7dc571e77956c99bf653bb6
> Author:     H. Peter Anvin<hpa@zytor.com>
> AuthorDate: Mon, 12 Oct 2009 14:14:10 -0700
> Committer:  H. Peter Anvin<hpa@zytor.com>
> CommitDate: Mon, 12 Oct 2009 14:19:35 -0700
>
> x86: use kernel_stack_pointer() in kprobes.c
>
> The way to obtain a kernel-mode stack pointer from a struct pt_regs in
> 32-bit mode is "subtle": the stack doesn't actually contain the stack
> pointer, but rather the location where it would have been marks the
> actual previous stack frame.  For clarity, use kernel_stack_pointer()
> instead of coding this weirdness explicitly.
>
> Signed-off-by: H. Peter Anvin<hpa@zytor.com>
> Cc: Ananth N Mavinakayanahalli<ananth@in.ibm.com>
> Cc: Anil S Keshavamurthy<anil.s.keshavamurthy@intel.com>
> Cc: "David S. Miller"<davem@davemloft.net>
> Cc: Masami Hiramatsu<mhiramat@redhat.com>

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

Thank you for fixing it!


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

