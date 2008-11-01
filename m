Return-Path: <linux-kernel-owner+w=401wt.eu-S1753138AbYKASnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbYKASnU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 14:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbYKASnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 14:43:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33442 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbYKASnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 14:43:09 -0400
Date: Sat, 1 Nov 2008 14:43:06 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: ftrace_dump_on_oops=[tracer]
In-Reply-To: <1225544744.21456.38.camel@lappy.programming.kicks-ass.net>
Message-ID: <alpine.DEB.1.10.0811011441210.13362@gandalf.stny.rr.com>
References: <1225544744.21456.38.camel@lappy.programming.kicks-ass.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 1 Nov 2008, Peter Zijlstra wrote:

> seems useful to debug crashes that happen before I read userspace.

Hmm, I think it might be better to separate this from the dump_on_oops.
How about a ftrace_default_tracer parameter?

If one is defined, it is activated as soon as it is initialized. This way 
we decouple the dump_on_oops, which we may not always want, and a way to 
start tracers before the switch to user space.

-- Steve
