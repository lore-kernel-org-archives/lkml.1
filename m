Return-Path: <linux-kernel-owner+w=401wt.eu-S1757519AbYAJUQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519AbYAJUQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 15:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751039AbYAJUQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 15:16:06 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:41299 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513AbYAJUQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 15:16:04 -0500
Date: Thu, 10 Jan 2008 15:15:58 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Tony Luck <tony.luck@intel.com>
cc: john stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
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
Subject: Re: [RFC PATCH 13/22 -v2] handle accurate time keeping over long
 delays
In-Reply-To: <12c511ca0801101154q224c7a43sa016190cf209d304@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0801101510210.15391@gandalf.stny.rr.com>
References: <20080109232914.676624725@goodmis.org>  <20080109233044.288563621@goodmis.org>
  <1199923219.6350.16.camel@localhost.localdomain>
 <12c511ca0801101154q224c7a43sa016190cf209d304@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I'm trying to figure out all the ramifications of the new
> "cycle_accumulated" field.  Does it really need to be

John,

Before we hardcode these names, can we change them?  Later in the series I
use something called 'cycle_raw' which really should be called
'cycle_accumulated'. Since cycle_accumulated IIRC can go backwards.

Or do you think I should rename cycle_raw to cycle_monotonic?

-- Steve

