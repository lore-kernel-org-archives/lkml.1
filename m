Return-Path: <linux-kernel-owner+w=401wt.eu-S1759685AbZJMNn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759685AbZJMNn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 09:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752417AbZJMNn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 09:43:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40299 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbZJMNn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 09:43:27 -0400
Subject: Re: [PATCH 2/3] tracing: Rename set_ftrace to set_bootup_ftrace
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>
In-Reply-To: <c62985530910130635k3127d163u3c6b6a46a96e3ffb@mail.gmail.com>
References: <1255419540-5481-1-git-send-email-fweisbec@gmail.com>
	 <1255419540-5481-3-git-send-email-fweisbec@gmail.com>
	 <1255440127.7113.1551.camel@gandalf.stny.rr.com>
	 <c62985530910130635k3127d163u3c6b6a46a96e3ffb@mail.gmail.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 13 Oct 2009 09:41:29 -0400
Message-Id: <1255441289.7113.1587.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-13 at 15:35 +0200, Frederic Weisbecker wrote:
> 2009/10/13 Steven Rostedt <rostedt@goodmis.org>:

> >> -__setup("ftrace=", set_ftrace);
> >> +__setup("ftrace=", set_bootup_ftrace);
> >
> > Actually, it probably should be called, set_cmdline_ftrace. Since it
> > came from the command line, and that is what is matching.
> >
> > -- Steve
> 
> No problem, I can change that in another request that also addresses
> Li's suggestion.

Yeah, I would label this as an extreme NON-critical change ;-)

-- Steve


