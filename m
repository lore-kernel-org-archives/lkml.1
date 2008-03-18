Return-Path: <linux-kernel-owner+w=401wt.eu-S932253AbYCSXV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253AbYCSXV2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933905AbYCSVtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:49:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938806AbYCSVti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:49:38 -0400
Message-ID: <47DFDF1E.7000600@redhat.com>
Date: Tue, 18 Mar 2008 11:26:22 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Yakov Lerner <iler.ml@gmail.com>
CC: prasanna@in.ibm.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kprobes: correct regs->ip value in post_hander()
References: <a8vQD-6wm-3@gated-at.bofh.it> <1205850409-12914-1-git-send-email-iler.ml@gmail.com>
In-Reply-To: <1205850409-12914-1-git-send-email-iler.ml@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yakov Lerner wrote:
> From: "Yakov Lerner" <iler.ml@gmail.com>
> 
>  This patch corrects the value of regs->ip in post_handler(). Prior to
>  this patch, post_handler() was given address meaningless to the user in 
>  regs->ip. The expected value is address of the next instruction to be 
>  executed after kprobed instruction. This patch simply swaps the order of
>  post_handler() and resume_execution(). post_handler() now sees the 
>  corrected, expected value in regs->ip. post_handler() is now called after
>  after resume_execution(), not before.
> 
>  Only x86 platform was tested. Arm arch needs no changes.
> 
> Signed-off-by: Yakov Lerner <iler.ml@gmail.com>

Thank you, I tested this on x86-64/x86/ia64.

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


