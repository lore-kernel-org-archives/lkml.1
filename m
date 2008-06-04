Return-Path: <linux-kernel-owner+w=401wt.eu-S1761339AbYFDSTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761339AbYFDSTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 14:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbYFDSTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 14:19:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35834 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbYFDSTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 14:19:47 -0400
Subject: Re: Stop machine threads are getting preemted by the rt period
	enforcement
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       rostedt@goodmis.org, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Paul Menage <menage@google.com>, "Randy.Dunlap" <rddunlap@osdl.org>,
       suresh.b.siddha@intel.com
In-Reply-To: <4846D9FE.4030804@qualcomm.com>
References: <20080601213019.14ea8ef8.pj@sgi.com>
	 <20080602164203.GA2477@sgi.com> <48443E66.6060205@qualcomm.com>
	 <20080602214151.GA7072@sgi.com> <48446D46.2010903@qualcomm.com>
	 <20080603144010.GA25948@sgi.com> <20080604140036.GC18993@sgi.com>
	 <4846D9FE.4030804@qualcomm.com>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 20:18:26 +0200
Message-Id: <1212603506.19205.2.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-04 at 11:07 -0700, Max Krasnyansky wrote:
> Peter, Ingo,
> 
> Take a look at the report below (came up during isolcpu= remove discussions).
> 
> It looks like stop_machine threads are getting forcefully preempted because
> they exceed their RT quanta. It's strange because rt period is pretty long.
> But given that disabling rt period logic solves the issue the machine was not
> really stuck.

Yeah, I know, I'm already looking at this

