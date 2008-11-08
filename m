Return-Path: <linux-kernel-owner+w=401wt.eu-S1754215AbYKHDzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbYKHDzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 22:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbYKHDzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 22:55:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:36523 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbYKHDzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 22:55:24 -0500
Date: Fri, 7 Nov 2008 22:55:22 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: linux-kernel@vger.kernel.org
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Matt Fleming <matthew.fleming@imgtec.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 08/10] ftrace: Align __mcount_loc sections
In-Reply-To: <20081108034750.183495492@goodmis.org>
Message-ID: <alpine.DEB.1.10.0811072250200.1444@gandalf.stny.rr.com>
References: <20081108034605.289816911@goodmis.org> <20081108034750.183495492@goodmis.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 7 Nov 2008, Steven Rostedt wrote:

> Impact: alignment option for recordmcount.pl script
> 
> Align the __mcount_loc sections so that architectures with strict
> alignment requirements need not worry about performing unaligned
> accesses.
> 
> This fixes an issue where I was seeing unaligned accesses, which are not
> supported on our architecture (the results of an unaligned access are
> undefined).
> 
> Signed-off-by: Matt Fleming <matthew.fleming@imgtec.com>
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>


Hmm, I have Matt as the Author in my git repository, but when I did the 
git format-patch and sent this off via quilt, it removed him as the author 
:-(

I may need to write a script to force the From line to be shown in the 
output files.

Here's the top of that file in my quilt tree that was produced:

-------------
>From 5c681e0fbbcecae2f446a5cce2d3556a536f9719 Mon Sep 17 00:00:00 2001
From: Matt Fleming <matthew.fleming@imgtec.com>
Date: Fri, 7 Nov 2008 13:26:25 +0000
Subject: [PATCH] ftrace: Align __mcount_loc sections

Impact: alignment option for recordmcount.pl script
--------------


Ingo, If you pull this from my git tree, it will keep the authorship 
correct.

Thanks,

-- Steve

