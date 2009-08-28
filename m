Return-Path: <linux-kernel-owner+w=401wt.eu-S1751730AbZH1ElS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730AbZH1ElS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 00:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbZH1ElS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 00:41:18 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:51593 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbZH1ElR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 00:41:17 -0400
Date: Fri, 28 Aug 2009 10:11:05 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip tracing/kprobes 4/6] kprobes: Fix to add __kprobes
	to notify_die
Message-ID: <20090828044105.GF7220@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20090827152539.GE6058@nowhere> <20090827172318.8246.53702.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090827172318.8246.53702.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 01:23:18PM -0400, Masami Hiramatsu wrote:
> Add __kprobes to notify_die() because do_int3() calls notify_die() instead of
> atomic_notify_call_chain() which is already marked as __kprobes.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
