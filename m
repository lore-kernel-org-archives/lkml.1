Return-Path: <linux-kernel-owner+w=401wt.eu-S1757209AbYJVTTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209AbYJVTTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 15:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbYJVTTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 15:19:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:65232 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbYJVTTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 15:19:13 -0400
Date: Wed, 22 Oct 2008 15:18:39 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       sagar.abhishek@gmail.com, davem@davemloft.net, tglx@linutronix.de,
       peterz@infradead.org, torvalds@linux-foundation.org,
       srostedt@redhat.com
Subject: Re: [PATCH 05/11] ftrace: only have ftrace_kill atomic
In-Reply-To: <20081022121128.5acc9ae0.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0810221516410.25759@gandalf.stny.rr.com>
References: <20081022184313.179487464@goodmis.org> <20081022185136.312667539@goodmis.org> <20081022121128.5acc9ae0.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 22 Oct 2008, Andrew Morton wrote:

> On Wed, 22 Oct 2008 14:43:18 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Only have a way to completely disable ftrace in atomic sections.
> > 
> 
> I have NFI what that means.
> 
> More importantly there is no explanation for *why* this change is being
> made.

Sorry, I'll explain it better in the next release. This was just something 
that Ingo wanted cleaned up. He prefers the name "ftrace_turn_off". I 
really don't care what the name is, but the "atomic" part was something 
that had to go.

What's your preference fo a name of a function that should completely 
disable ftrace on anomaly detection?  Unfortunately, ftrace_stop, 
ftrace_disable, and ftrace_shutdown are already in use.

-- Steve

