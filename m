Return-Path: <linux-kernel-owner+w=401wt.eu-S1754867AbYHYQiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbYHYQiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 12:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbYHYQio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 12:38:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49193 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbYHYQio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 12:38:44 -0400
Date: Mon, 25 Aug 2008 12:38:42 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Tracing/ftrace: Adds a marker to allow user comments
In-Reply-To: <c62985530808250659w5b2a2f83u689987969a4cb53d@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0808251237340.23923@gandalf.stny.rr.com>
References: <48B1D5CA.8000607@gmail.com> <20080825084405.GA29195@elte.hu> <c62985530808250659w5b2a2f83u689987969a4cb53d@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 25 Aug 2008, Fr?d?ric Weisbecker wrote:

> 2008/8/25 Ingo Molnar <mingo@elte.hu>:
> >
> > * Fr?d?ric Weisbecker <fweisbec@gmail.com> wrote:
> >
> >> The documentation of mmiotrace describes an unimplemented feature
> >> which allows the user to write any comments on his trace by writing on
> >> a tracing/marker file. Here is an implementation of this idea.
> >>
> >> It applies on last version of tip tree.
> >
> > hmm ... have you looked at the (recently implemented) ftrace_printk()
> > facility?
> >
> >        Ingo
> >
> 
> Yes but I didn't want to use ftrace_printk() because it needs the "ip"
> parameter. User messages doesn't need this. But I reuse a part of the
> code of ftrace_printk and I splitted ftrace_printk() in two parts for
> this purpose: __ftrace_printk() and trace_print().
> I also reused the print_entry but with a new TRACE_MARK type to make
> the difference when it is time to send the entry to the pipe because
> user messages don't use ip.


Feel free to make TRACE_CONT work for you. I coupled it a little more than 
I wanted to with the ftrace print. If you can find a nice way to make 
TRACE_CONT a bit more generic, then feel free.

-- Steve

