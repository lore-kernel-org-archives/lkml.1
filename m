Return-Path: <linux-kernel-owner+w=401wt.eu-S1752772AbYLWQk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbYLWQk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 11:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750903AbYLWQkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 11:40:18 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34250 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbYLWQkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 11:40:17 -0500
Date: Tue, 23 Dec 2008 11:40:16 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: linux-kernel@vger.kernel.org
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH 0/2] ring-buffer: updates for 2.6.28
In-Reply-To: <20081223163223.625941559@goodmis.org>
Message-ID: <alpine.DEB.1.10.0812231138330.26669@gandalf.stny.rr.com>
References: <20081223163223.625941559@goodmis.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


My scripts did not CC to the 'Reported-by' field, so they did not include 
Jiaying. Please add him to any replys to the patches. I privately forward 
them to him so he did get them.

Thanks,

-- Steve


On Tue, 23 Dec 2008, Steven Rostedt wrote:

> 
> Ingo,
> 
> These two patches should go to 2.6.28. They are fixes to the ring buffer
> for bugs that will make the ring buffer stop reading, and/or produce
> a false positive.
> 
> If these are too late for 2.6.28, then we probably should get them at least
> to the stable branch and queued for 2.6.28.1.
> 
> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: devel
> 
> 
> Steven Rostedt (2):
>       ring-buffer: fix dangling commit race
>       ring-buffer: prevent false positive warning
> 
> ----
>  kernel/trace/ring_buffer.c |   19 +++++++++++++++++--
>  1 files changed, 17 insertions(+), 2 deletions(-)
> 
> 
