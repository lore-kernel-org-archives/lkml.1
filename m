Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbYGEX3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbYGEX3V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 19:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbYGEX3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 19:29:14 -0400
Received: from [194.117.236.238] ([194.117.236.238]:54500 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbYGEX3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 19:29:13 -0400
Date: Sun, 6 Jul 2008 02:27:11 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC patch 00/12] Tracepoints v2
Message-ID: <20080706022711.199401fe@linux360.ro>
In-Reply-To: <20080704235207.147809973@polymtl.ca>
References: <20080704235207.147809973@polymtl.ca>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Jul 2008 19:52:07 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Hi,
> 
> Here is the second release of kernel tracepoints, including the
> architecture independent instrumentation taken from LTTng. I submit
> this for another round of comments.

Hi,

Not using format specifiers sounds pretty nice. Are there any other
advantages over markers? What about self-modifying code, does it employ
this technique to eliminate conditional branching (markers did this on
some arches, IIRC)?

I'm considering using this for kmemtrace, so please keep me Cc-ed if
possible.


	Cheers,
	Eduard

P.S.: BTW, the To header is either broken or I screwed it (I'm reading
this via Gmane's NNTP):
"Steven Rostedt <ros"
