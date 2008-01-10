Return-Path: <linux-kernel-owner+w=401wt.eu-S1757314AbYAJUls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbYAJUls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 15:41:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755945AbYAJUl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 15:41:27 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:49999 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750AbYAJUl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 15:41:26 -0500
Subject: Re: [RFC PATCH 13/22 -v2] handle accurate time keeping over long
	delays
From: john stultz <johnstul@us.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <Pine.LNX.4.58.0801101510210.15391@gandalf.stny.rr.com>
References: <20080109232914.676624725@goodmis.org>
	 <20080109233044.288563621@goodmis.org>
	 <1199923219.6350.16.camel@localhost.localdomain>
	 <12c511ca0801101154q224c7a43sa016190cf209d304@mail.gmail.com>
	 <Pine.LNX.4.58.0801101510210.15391@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Thu, 10 Jan 2008 12:41:17 -0800
Message-Id: <1199997677.6108.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-10 at 15:15 -0500, Steven Rostedt wrote:
> > I'm trying to figure out all the ramifications of the new
> > "cycle_accumulated" field.  Does it really need to be
> 
> John,
> 
> Before we hardcode these names, can we change them?  Later in the series I
> use something called 'cycle_raw' which really should be called
> 'cycle_accumulated'. Since cycle_accumulated IIRC can go backwards.

Err... I don't think the current cycle_accumulated can go backwards. Or
maybe I'm missing what you mean.

> Or do you think I should rename cycle_raw to cycle_monotonic?

That's fine by me either way.

thanks
-john


