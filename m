Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbZJERez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbZJERez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 13:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159AbZJERey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 13:34:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49875 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130AbZJERex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 13:34:53 -0400
Subject: Re: [PATCH 02/21] ftrace.c: Add #define pr_fmt(fmt) KBUILD_MODNAME
 ": " fmt
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
In-Reply-To: <1254763312.1799.507.camel@Joe-Laptop.home>
References: <cover.1254701151.git.joe@perches.com>
	 <9b377eefae9e28c599dd4a17bdc81172965e9931.1254701151.git.joe@perches.com>
	 <1254748256.13160.0.camel@gandalf.stny.rr.com>
	 <1254763312.1799.507.camel@Joe-Laptop.home>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Mon, 05 Oct 2009 13:32:54 -0400
Message-Id: <1254763974.13160.9.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-05 at 10:21 -0700, Joe Perches wrote:
> On Mon, 2009-10-05 at 09:10 -0400, Steven Rostedt wrote:
> > On Sun, 2009-10-04 at 17:53 -0700, Joe Perches wrote:
> > > Remove prefixes from pr_<level>, use pr_fmt(fmt)
> > > No change in output.
> > What does KBUILD_MODNAME give us in the core code? This file does not
> > belong to any module and is only compiled into the core kernel.
> 
> Hi Steven.
> 
> KBUILD_MODNAME is basename(__FILE__), or if multiple files are
> grouped in the Makefile, then it's the basename(group)
> 
> http://lkml.indiana.edu/hypermail/linux/kernel/0210.2/0325.html
> 
> For ftrace.c, it gives "ftrace", which is the same
> as the prefix you were using, so there's no change
> in the output.

If it keeps the same output, and doesn't change when it may be printed,
then you can add my:

Acked-by: Steven Rostedt <rostedt@goodmis.org>

to that one patch.

-- Steve


