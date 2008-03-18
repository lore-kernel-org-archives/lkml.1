Return-Path: <linux-kernel-owner+w=401wt.eu-S1761940AbYCSVFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761940AbYCSVFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbYCSTzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:55:12 -0400
Received: from over.ny.us.ibm.com ([32.97.182.150]:54176 "EHLO
	over.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644AbYCSTy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:54:57 -0400
Date: Tue, 18 Mar 2008 21:26:45 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Yakov Lerner <iler.ml@gmail.com>
Cc: mhiramat@redhat.com, prasanna@in.ibm.com, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kprobes: correct regs->ip value in post_hander()
Message-ID: <20080318155645.GA6794@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <a8vQD-6wm-3@gated-at.bofh.it> <1205850409-12914-1-git-send-email-iler.ml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205850409-12914-1-git-send-email-iler.ml@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2008 at 09:26:49AM -0500, Yakov Lerner wrote:
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

Tested on powerpc.

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Thanks Yakov!
