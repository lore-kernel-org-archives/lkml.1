Return-Path: <linux-kernel-owner+w=401wt.eu-S1760188AbXJaQ2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760188AbXJaQ2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 12:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756723AbXJaQ2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 12:28:23 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42868 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321AbXJaQ2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 12:28:22 -0400
Date: Wed, 31 Oct 2007 09:28:03 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH] dump_stack on panic
Message-ID: <20071031092803.0048d5d6@laptopd505.fenrus.org>
In-Reply-To: <Pine.LNX.4.58.0710311034410.16249@gandalf.stny.rr.com>
References: <1193788979.5623.43.camel@localhost.localdomain>
	<20071031071907.2d1b02ed@laptopd505.fenrus.org>
	<Pine.LNX.4.58.0710311034410.16249@gandalf.stny.rr.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2007 11:00:56 -0400 (EDT)
Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> I've had too many issues in development where I hit a panic and it
> gives me nothing to tell me why.
> 
> At the very least, we should have a dump_stack in areas that are
> usually caused by kernel bugs. For example, killing an interrupt
> handler.
> 

here's the deal.... the killing of an interrupt handler because of an
oops THEN causes a panic. If you dump stack AGAIN, you have 2 stack
traces, with the first one being the real good one, and the second one
being.. well more crappy... so you proposal just dropped the good
stacktrace off the screen in favor of a worse one...




-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
