Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbZCQPaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbZCQPaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 11:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753982AbZCQPaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 11:30:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35925 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbZCQPaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 11:30:01 -0400
Date: Tue, 17 Mar 2009 11:29:57 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Christoph Hellwig <hch@infradead.org>
cc: Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: [patch 3/4] genirq: add a quick check handler
In-Reply-To: <20090317075417.GD3331@infradead.org>
Message-ID: <alpine.DEB.2.00.0903171128280.10274@gandalf.stny.rr.com>
References: <20090226131336.423054348@linutronix.de> <20090226131719.640887792@linutronix.de> <20090228222408.GB7797@infradead.org> <1236283149.20484.31.camel@sven.thebigcorporation.com> <20090317075417.GD3331@infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 17 Mar 2009, Christoph Hellwig wrote:
> 
> I wonder if you're still thinking in the way of a -RT like setup where
> threaded interrupts can be enabled and disabled globally?  I don't think
> we should ever do that for mainline.

I agree with this statement. You either want the interrupts as threads or 
you don't. Honestly, I've never used the enable/disable threaded 
interrupts feature in -rt except to test if it worked. But we recommend 
against using it.

-- Steve

