Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbZIUN2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbZIUN2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 09:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753158AbZIUN2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 09:28:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:41332 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbZIUN2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 09:28:42 -0400
Date: Mon, 21 Sep 2009 15:28:53 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       mingo@elte.hu
Subject: Re: TRACE_EVENT_ABI ?
Message-ID: <20090921152853.2f8c0597@infradead.org>
In-Reply-To: <alpine.DEB.2.00.0909210926010.7647@gandalf.stny.rr.com>
References: <20090921093652.0722d745@infradead.org>
	<alpine.DEB.2.00.0909210926010.7647@gandalf.stny.rr.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Sep 2009 09:26:41 -0400 (EDT)
Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> [ Resending due to wrong SMTP server ]
> 
> 
> On Mon, 21 Sep 2009, Arjan van de Ven wrote:
> 
> > Hi,
> > 
> > Ingo suggested to make a TRACE_EVENT_ABI, which is equivalent in
> > implementation to TRACE_EVENT, except that it signals a stable
> > interface.
> > 
> > In trying to implement this I'm running into a wall where
> > TRACE_EVENT keeps being defined in many different ways all over the
> > place, making this a really nasty hack to make it just an alias.
> > 
> > Do you have any clever ideas on how to make this an alias without
> > fouling up the whole tracing system?
> > 
> 
> I don't know what you've done so far, but can't you simply in
> tracepoint.h define:
> 
> #define TRACE_EVENT_API(a,b,c,d,e) TRACE_EVENT(a,b,c,d,e)

unfortunately, due to the preprocessor trickery around TRACE_EVENT this
completely barfs.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
