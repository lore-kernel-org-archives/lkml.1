Return-Path: <linux-kernel-owner+w=401wt.eu-S1753451AbYJ0R3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbYJ0R3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 13:29:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbYJ0R2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 13:28:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:45482 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbYJ0R2w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 13:28:52 -0400
Date: Mon, 27 Oct 2008 10:29:13 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?UTF-8?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RESEND] ftrace: Add a script to produce a hierarchical
 view of a function trace
Message-ID: <20081027102913.33c51ba6@infradead.org>
In-Reply-To: <20081027102757.GK8116@elte.hu>
References: <4904DF39.9070203@gmail.com>
	<alpine.DEB.1.10.0810261903110.26269@gandalf.stny.rr.com>
	<490513D5.7080806@gmail.com>
	<20081027100148.GB8116@elte.hu>
	<c62985530810270326v79528ca9ne88c2c3c9da6558c@mail.gmail.com>
	<20081027102757.GK8116@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2008 11:27:57 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
> 
> > 2008/10/27 Ingo Molnar <mingo@elte.hu>:
> > > nice! Applied it to tip/tracing/ftrace. I've added Steve's
> > > Acked-by,
> > 
> > 
> > Thanks!
> > 
> > 
> > > and i've moved the script to scripts/tracing/ - now that we'll
> > > have a handful of utility scripts there we might as well separate
> > > it a bit more clearly from the usual body of kernel scripts.
> > >
> > > i think we should move the other utility scripts there too. (but
> > > not the recordmcount script - that is an infrastructure script,
> > > not a utility script)
> > 
> > 
> > Good idea, for example bootgraph.pl matches the case, if Arjan
> > agrees.
> 

bootgraph.pl is sort of borderline since it also works without tracing
but I'm not opposed to it if it makes scripts/ more organized
