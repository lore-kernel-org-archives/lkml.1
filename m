Return-Path: <linux-kernel-owner+w=401wt.eu-S1751777AbZH1Eky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777AbZH1Eky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 00:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbZH1Ekx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 00:40:53 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34528 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbZH1Ekx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 00:40:53 -0400
Date: Fri, 28 Aug 2009 10:10:42 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip tracing/kprobes 3/6] kprobes/x86: Fix to add
	__kprobes to in-kernel fault handing functions
Message-ID: <20090828044042.GE7220@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20090827152539.GE6058@nowhere> <20090827172311.8246.92725.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090827172311.8246.92725.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 01:23:11PM -0400, Masami Hiramatsu wrote:
> Add __kprobes to the functions which handles in-kernel fixable page faults.
> Since kprobes can cause those in-kernel page faults by accessing kprobe data
> structures, probing those fault functions will cause fault-int3-loop
> (do_page_fault has already been marked as __kprobes).
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
