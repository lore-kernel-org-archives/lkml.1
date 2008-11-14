Return-Path: <linux-kernel-owner+w=401wt.eu-S1752817AbYKNDEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbYKNDEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 22:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbYKNDEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 22:04:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39919 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbYKNDEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 22:04:42 -0500
Date: Thu, 13 Nov 2008 22:04:39 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Needed fix for set_ftrace_filter
Message-ID: <alpine.DEB.1.10.0811132158480.17523@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I noticed that the set_ftrace_filter in mainline is badly broken. It 
displays all files (incorrectly) and lets you only filter once. After 
that, it does not filter anymore.

Here's the posted fix:

  http://marc.info/?l=linux-kernel&m=122611613419814&w=2

and it is in tip:

   commit 0183fb1c94b74862b073590fc52c56b7364b7bad

   ftrace: fix set_ftrace_filter


Could you get that pushed up to Linus. I cherry picked it into my local 
mainline git repo, and it worked fine.

Thanks,

-- Steve


