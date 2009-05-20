Return-Path: <linux-kernel-owner+w=401wt.eu-S1755606AbZETIMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbZETIMW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 04:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbZETIMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 04:12:10 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36427 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbZETIMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 04:12:08 -0400
Date: Wed, 20 May 2009 09:11:50 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tim Bird <tim.bird@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Steven Rostedt <rostedt@goodmis.org>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 2/2] ftrace: add function-graph tracer support for ARM
	v2
Message-ID: <20090520081150.GA22558@n2100.arm.linux.org.uk>
References: <49FB79CF.3020101@am.sony.com> <20090502001100.GH6404@nowhere> <c62985530905090914odb4dcc6pc7ea789f02515167@mail.gmail.com> <20090515210636.GQ650@n2100.arm.linux.org.uk> <20090520023432.GJ6066@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090520023432.GJ6066@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20, 2009 at 04:34:35AM +0200, Frederic Weisbecker wrote:
> On Fri, May 15, 2009 at 10:06:36PM +0100, Russell King - ARM Linux wrote:
> > However, I'm not sure that this code is entirely right (and I'm not
> > sure what's going on with this patch - my editor is randomly changing
> > the placement of characters in it.  Are you submitting patches using
> > UTF-8 characters in the code?)
> > 
> > > >> @@ -139,8 +144,16 @@ ENTRY(mcount)
> > > >>       adr r0, ftrace_stub
> > > >>       cmp r0, r2
> > > >>       bne trace
> > 
> > If this is r0 != ftrace_stub, go to trace.  So the next block will
> > only be executed if r0 /was/ ftrace_stub, in which case it can't be
> > ftrace_graph_return.
> 
> Ah! This part concerns the function tracer.
> Let's see how it looks like in the original code: (added more comments
> inside)

You've completely missed the point I was trying to make.  Please go back
and re-read my email and think about precisely what's happening in the
assembly path, particularly which branches will be taken and which code
paths will be taken with various values of r2.

