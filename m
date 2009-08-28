Return-Path: <linux-kernel-owner+w=401wt.eu-S1751744AbZH1Eja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbZH1Eja (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 00:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbZH1Eja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 00:39:30 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:56932 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbZH1Ej3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 00:39:29 -0400
Date: Fri, 28 Aug 2009 10:09:15 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip tracing/kprobes 2/6] kprobes/x86-64: Allow to
	reenter probe on post_handler
Message-ID: <20090828043915.GD7220@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20090827152539.GE6058@nowhere> <20090827172304.8246.4822.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090827172304.8246.4822.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 01:23:04PM -0400, Masami Hiramatsu wrote:
> Allow to reenter probe on the post_handler of another probe on x86-64,
> because x86-64 already allows reentering int3.
> In that case, reentered probe just increases kp.nmissed and returns.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
