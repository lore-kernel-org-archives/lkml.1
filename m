Return-Path: <linux-kernel-owner+w=401wt.eu-S1762149AbZLKB2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762149AbZLKB2K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 20:28:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762050AbZLKB2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 20:28:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761765AbZLKB2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 20:28:08 -0500
Date: Thu, 10 Dec 2009 20:27:38 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       utrace-devel <utrace-devel@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] [PATCH] In-kernel gdbstub based on utrace Infrastructure.
Message-ID: <20091211012738.GA646@redhat.com>
References: <20091130152910.GB10331@redhat.com> <20091201161132.GA24897@elte.hu> <20091201170002.GD10331@redhat.com> <20091201170954.GA4699@elte.hu> <20091201174534.GE10331@redhat.com> <20091201211518.GA32376@elte.hu> <20091208215829.GA19793@redhat.com> <20091210074158.GI16874@elte.hu> <y0mhbryamt2.fsf@fche.csb> <20091210181638.GA17986@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091210181638.GA17986@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Thu, Dec 10, 2009 at 07:16:38PM +0100, Ingo Molnar wrote:
> [...]
> > The gdbstub prototype was constructed for two reasons: to demonstrate 
> > utrace usage now, and in the future to be incrementally useful (over 
> > ptrace, by moving into fast kernel-space operations like 
> > multithreading control, gdb-tracepoint support, other stuff).  [...]
> 
> What i'd like to see is measurable benefits to users, developers and 
> maintainers. 

OK, it's clear that in the gdb-stub's case, some positive motivation
beyond it being an api-educational example would be appropriate before
merging.  Note that it was only an RFC at the time.


> I'd like to see the same for SystemTap too btw.

systemtap's benefits are beyond question to its users.  (Others are
worried about systemtap problems, but that wasn't your question.)  In
what form do you expect to see such measurements?  It would help if
you could point out prior examples of such "measurable benefit"
analyses that perchance accompanied other then-new kernel features,
say in the tracing/debugging area.


- FChE
