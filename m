Return-Path: <linux-kernel-owner+w=401wt.eu-S1751815AbZH1Elt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815AbZH1Elt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 00:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751759AbZH1Els
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 00:41:48 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:36773 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbZH1Els (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 00:41:48 -0400
Date: Fri, 28 Aug 2009 10:11:35 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip tracing/kprobes 6/6] kprobes: Prohibit to probe
	native_get_debugreg
Message-ID: <20090828044135.GG7220@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20090827152539.GE6058@nowhere> <20090827172332.8246.34194.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090827172332.8246.34194.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 01:23:32PM -0400, Masami Hiramatsu wrote:
> Since do_debug() calls get_debugreg(), native_get_debugreg() will be called
> from singlestepping. This can cause an int3 infinit loop.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
