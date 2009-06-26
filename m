Return-Path: <linux-kernel-owner+w=401wt.eu-S1758403AbZFZJTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403AbZFZJTW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 05:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754442AbZFZJTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 05:19:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59576 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754382AbZFZJTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 05:19:13 -0400
Date: Fri, 26 Jun 2009 10:20:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@mail.by>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: kmemleak suggestion (long message)
Message-ID: <20090626102008.31a67543@lxorguk.ukuu.org.uk>
In-Reply-To: <1246006463.30717.12.camel@pc1117.cambridge.arm.com>
References: <20090625221816.GA3480@localdomain.by>
	<20090626065923.GA14078@elte.hu>
	<84144f020906260007u3e79086bv91900e487ba0fb50@mail.gmail.com>
	<20090626081452.GB3451@localdomain.by>
	<1246004270.27533.16.camel@penberg-laptop>
	<20090626085056.GC3451@localdomain.by>
	<1246006463.30717.12.camel@pc1117.cambridge.arm.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jun 2009 09:54:23 +0100
Catalin Marinas <catalin.marinas@arm.com> wrote:

> On Fri, 2009-06-26 at 11:50 +0300, Sergey Senozhatsky wrote:
> > On (06/26/09 11:17), Pekka Enberg wrote:
> > > Well, the thing is, I am not sure it's needed if we implement Ingo's
> > > suggestion. After all, syslog is no longer spammed very hard and you can
> > > do all the filtering in userspace when you read /debug/mm/kmemleak file,
> > > no?
> > 
> > Well, we just move 'spam' out of syslog. Not dealing with 'spam' itself.
> > I'm not sure about 'filtering in userspace when you read'. Suppose I use
> > 'tail -f /debug/mm/kmemleak'. How can I easy suppress printing of (for example):
> 
> I don't have a strong opinion on this patch at the moment, I'll have a
> look later today.
> 
> > Or any report with tty_ldisc_try_get (ppp generates tons of them).
> 
> BTW, that's a real leak IMHO (posted a patch yesterday in reply to the
> initial report to Alan Cox).

Yes its on my todo list - probably for early next week along with nailing
down a couple of warnings suggesting there is another race lurking
somewhere.
