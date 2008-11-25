Return-Path: <linux-kernel-owner+w=401wt.eu-S1752897AbYKYXbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbYKYXbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 18:31:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750895AbYKYXba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 18:31:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42514 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750890AbYKYXb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 18:31:29 -0500
Date: Tue, 25 Nov 2008 15:31:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       srostedt@redhat.com
Subject: Re: [PATCH 1/3] ftrace: add function tracing to single thread
Message-Id: <20081125153104.ecdceed4.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0811251800130.26424@gandalf.stny.rr.com>
References: <20081125223421.795046329@goodmis.org>
	<20081125223456.976670734@goodmis.org>
	<20081125144221.66eb99ad.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0811251800130.26424@gandalf.stny.rr.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2008 18:01:06 -0500 (EST)
Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Tue, 25 Nov 2008, Andrew Morton wrote:
> 
> > On Tue, 25 Nov 2008 17:34:22 -0500
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > This patch adds the ability to function trace a single thread.
> > > The file:
> > > 
> > >   /debugfs/tracing/set_ftrace_pid
> > > 
> > > contains the pid to trace.
> > 
> > What happens if the same pid exists in two or more pid namespaces?
> 
> I think we had this discussion before.

Oh.  What did we end up concluding?

> It tests current->pid, would that 
> be different among the name spaces?

I think those are non-unique.  containers@lists.osdl.org would have
better ideas..

