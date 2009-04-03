Return-Path: <linux-kernel-owner+w=401wt.eu-S933610AbZDCQZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933610AbZDCQZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbZDCQYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 12:24:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38809 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755AbZDCQYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 12:24:54 -0400
Date: Fri, 3 Apr 2009 12:24:52 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/ftrace: factorize the tracing files creation
In-Reply-To: <1238109938-11840-1-git-send-email-fweisbec@gmail.com>
Message-ID: <alpine.DEB.2.00.0904031224130.21481@gandalf.stny.rr.com>
References: <1238109938-11840-1-git-send-email-fweisbec@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Fri, 27 Mar 2009, Frederic Weisbecker wrote:

> Impact: cleanup
> 
> Most of the tracing files creation follow the same pattern:
> 
> ret = debugfs_create_file(...)
> if (!ret)
> 	pr_warning("Couldn't create ... entry\n")
> 
> Unify it!
> 
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks, applied.

Note, I only applied it to tracing/ftrace, which does not have the 
profiler code. That part of the patch has been rejected.

-- Steve

