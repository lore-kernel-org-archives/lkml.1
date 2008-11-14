Return-Path: <linux-kernel-owner+w=401wt.eu-S1753033AbYKNEG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033AbYKNEG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 23:06:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754505AbYKNEGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 23:06:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41213 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbYKNEGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 23:06:44 -0500
Date: Thu, 13 Nov 2008 23:06:41 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Needed fix for set_ftrace_filter
In-Reply-To: <alpine.DEB.1.10.0811132158480.17523@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0811132303560.17523@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0811132158480.17523@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 13 Nov 2008, Steven Rostedt wrote:

> 
> Ingo,
> 
> I noticed that the set_ftrace_filter in mainline is badly broken. It 
> displays all files (incorrectly) and lets you only filter once. After 
> that, it does not filter anymore.

OK, only the output is broken. I confused myself by not setting the right
function and then not seeing it print. But because I can not see what
filters are set, I did not notice I typed the wrong function.

Still, this is a easy fix (3 lines changed) for an annoying bug.

-- Steve

> 
> Here's the posted fix:
> 
>   http://marc.info/?l=linux-kernel&m=122611613419814&w=2
> 
> and it is in tip:
> 
>    commit 0183fb1c94b74862b073590fc52c56b7364b7bad
> 
>    ftrace: fix set_ftrace_filter
> 
> 
> Could you get that pushed up to Linus. I cherry picked it into my local 
> mainline git repo, and it worked fine.
> 
> Thanks,
> 
> -- Steve
> 
> 
> 
