Return-Path: <linux-kernel-owner+w=401wt.eu-S1752776AbYKZQzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbYKZQzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 11:55:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbYKZQzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 11:55:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45949 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbYKZQzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 11:55:42 -0500
Date: Wed, 26 Nov 2008 11:55:37 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, containers@lists.osdl.org,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/5] ftrace: add function tracing to single thread
In-Reply-To: <20081126065425.GA26036@elte.hu>
Message-ID: <alpine.DEB.1.10.0811261155200.26743@gandalf.stny.rr.com>
References: <20081126051622.134970943@goodmis.org> <20081126051709.571204072@goodmis.org> <m1hc5vasye.fsf@frodo.ebiederm.org> <20081126065425.GA26036@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 26 Nov 2008, Ingo Molnar wrote:

> 
> * Eric W. Biederman <ebiederm@xmission.com> wrote:
> 
> > > +/* ftrace_pid_trace >= 0 will only trace threads with this pid */
> > > +static int ftrace_pid_trace = -1;
> > 
> > Why not?
> > static struct pid *ftrace_pid_trace = NULL;
> 
> ok, looks reasonably simple at first sight.
> 
> Steve, mind sending the conversion of this facility to struct pid as a 
> delta patch? (that would have education purposes as well, for similar 
> situations)

If I can trace specific kernel threads too, then I have no problem with 
it.

-- Steve

