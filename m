Return-Path: <linux-kernel-owner+w=401wt.eu-S932518AbZDCQno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518AbZDCQno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755646AbZDCQne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 12:43:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61943 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479AbZDCQnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 12:43:33 -0400
Date: Fri, 3 Apr 2009 12:43:15 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, fweisbec@gmail.com
Subject: Re: [PATCH] tracing/filters: allow event filters to be set only when
 not tracing
In-Reply-To: <20090403163755.GA3047@elte.hu>
Message-ID: <alpine.DEB.2.00.0904031241280.21481@gandalf.stny.rr.com>
References: <1238390546.6368.65.camel@bookworm> <20090401122408.GG12966@elte.hu> <1238653371.6655.48.camel@bookworm> <20090403135956.GD8875@elte.hu> <20090403162642.GB6968@linux.vnet.ibm.com> <20090403163755.GA3047@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 3 Apr 2009, Ingo Molnar wrote:
> > 
> > My kneejerk reaction is "why would anyone want to trace the idle 
> > loop?"
> 
> heh :-)
> 
> Idle enter/exit events are useful to tune power use for example. The 
> more events we have there, the more we prevent the CPU from slowly 
> going into deep sleep mode.

I can say I use it a lot. I'm still needing a way to set the function pid 
recorder to 0 since the conversion to the pid structure. There are times 
I only want to trace the interrupts that happen in the idle loop.

-- Steve

