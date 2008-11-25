Return-Path: <linux-kernel-owner+w=401wt.eu-S1754006AbYKYXBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbYKYXBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 18:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbYKYXBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 18:01:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:56548 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbYKYXBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 18:01:08 -0500
Date: Tue, 25 Nov 2008 18:01:06 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       srostedt@redhat.com
Subject: Re: [PATCH 1/3] ftrace: add function tracing to single thread
In-Reply-To: <20081125144221.66eb99ad.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0811251800130.26424@gandalf.stny.rr.com>
References: <20081125223421.795046329@goodmis.org> <20081125223456.976670734@goodmis.org> <20081125144221.66eb99ad.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 25 Nov 2008, Andrew Morton wrote:

> On Tue, 25 Nov 2008 17:34:22 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > This patch adds the ability to function trace a single thread.
> > The file:
> > 
> >   /debugfs/tracing/set_ftrace_pid
> > 
> > contains the pid to trace.
> 
> What happens if the same pid exists in two or more pid namespaces?

I think we had this discussion before. It tests current->pid, would that 
be different among the name spaces?

-- Steve

