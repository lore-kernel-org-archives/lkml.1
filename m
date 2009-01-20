Return-Path: <linux-kernel-owner+w=401wt.eu-S1761274AbZATAmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761274AbZATAmo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 19:42:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbZATAme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 19:42:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40214 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204AbZATAme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 19:42:34 -0500
Date: Mon, 19 Jan 2009 19:42:32 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: linux-kernel@vger.kernel.org
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/8] ftrace: updates to tip
In-Reply-To: <alpine.DEB.1.10.0901191940210.8778@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0901191942100.8778@gandalf.stny.rr.com>
References: <20090120001542.687427797@goodmis.org> <alpine.DEB.1.10.0901191940210.8778@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 19 Jan 2009, Steven Rostedt wrote:
> On Mon, 19 Jan 2009, Steven Rostedt wrote:
> 
> > Ingo,
> > 
> > The one patch I did here, will need to go to stable as well. I'll write
> > up a patch against stable, and as soon as it gets into Linus's tree,
> > it should also be pulled into stable as well. Without the patch, some
> > archs will not be able to perform any tracing. There is an alignment
> > issue that will cause the ring buffer to fail to commit any transactions.
> > 
> 
> False alarm on the stable side. The code in question did not make it in 
> 2.6.28, so there is nothing to worry about there.

But it does need to get into 2.6.29.

-- Steve

