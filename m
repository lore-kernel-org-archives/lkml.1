Return-Path: <linux-kernel-owner+w=401wt.eu-S1423030AbXD3Ftk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423030AbXD3Ftk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 01:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423037AbXD3Ftk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 01:49:40 -0400
Received: from ozlabs.org ([203.10.76.45]:32959 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423030AbXD3Ftj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 01:49:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17973.33249.852991.342860@cargo.ozlabs.ibm.com>
Date: Mon, 30 Apr 2007 15:42:57 +1000
From: Paul Mackerras <paulus@samba.org>
To: Anton Blanchard <anton@samba.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: Incorrect order of last two arguments of ptrace for requests
	PPC_PTRACE_GETREGS, SETREGS, GETFPREGS, SETFPREGS
In-Reply-To: <20061204215825.GB22514@krispykreme>
References: <453F421A.6070507@in.ibm.com>
	<1164220580.12365.8.camel@hades.cambridge.redhat.com>
	<20061204215825.GB22514@krispykreme>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Blanchard writes:

> I looked at this a while ago and my decision at the time was to keep the
> old implementation around for a while and create two new ones that match
> the x86 numbering:
> 
> #define PTRACE_GETREGS            12
> #define PTRACE_SETREGS            13
> #define PTRACE_GETFPREGS          14
> #define PTRACE_SETFPREGS          15
> 
> I hate gratuitous differences, each ptrace app ends up with a sea of
> ifdefs.
> 
> Also I think it would be worth changing getregs/setregs to grab the
> entire pt_regs structure. Otherwise most ops (gdb, strace etc) will just
> have to make multiple ptrace calls to get the nia etc.

Did you do a patch to do that?

Paul.
