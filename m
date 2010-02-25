Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633Ab0BYOBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 09:01:32 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:45883 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932357Ab0BYOBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 09:01:30 -0500
Date: Thu, 25 Feb 2010 15:01:21 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu
Subject: Re: [PATCH 19/28] mips,kgdb: kdb low level trap catch and stack trace
Message-ID: <20100225140121.GA5616@linux-mips.org>
References: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com>
 <1266014143-29444-20-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266014143-29444-20-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 12, 2010 at 04:35:34PM -0600, Jason Wessel wrote:

> The only way the debugger can handle a trap in inside rcu_lock,
> notify_die, or atomic_notifier_call_chain without a recursive fault is
> to have a low level "first opportunity handler" do_trap_or_bp() handler.
> 
> Generally this will be something the vast majority of folks will not
> need, but for those who need it, it is added as a kernel .config
> option called KGDB_LOW_LEVEL_TRAP.
> 
> Also added was a die notification for oops such that kdb can catch an
> oops for analysis.
> 
> There appeared to be no obvious way to pass the struct pt_regs from
> the original exception back to the stack back tracer, so a special
> case was added to show_stack() for when kdb is active because you
> generally desire to generally look at the back trace of the original
> exception.
> 
> CC: Ralf Baechle <ralf@linux-mips.org>
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
