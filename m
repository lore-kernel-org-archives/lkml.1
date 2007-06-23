Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbXFWTqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbXFWTqo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 15:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbXFWTqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 15:46:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60254 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751482AbXFWTqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 15:46:36 -0400
Date: Sat, 23 Jun 2007 12:39:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hch@infradead.org, johnstul@us.ibm.com, oleg@tv-sign.ru,
       paulmck@linux.vnet.ibm.com, dipankar@in.ibm.com, davem@davemloft.net,
       kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 5/5 v2] Convert tasklets to work queues
Message-Id: <20070623123956.6ded42c1.akpm@linux-foundation.org>
In-Reply-To: <1182626869.5493.143.camel@localhost.localdomain>
References: <20070622182051.859570787@goodmis.org>
	<20070622182315.571740041@goodmis.org>
	<20070623095359.4667514e.akpm@linux-foundation.org>
	<alpine.LFD.0.98.0706231113200.3593@woody.linux-foundation.org>
	<1182626869.5493.143.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jun 2007 15:27:49 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:

> On Sat, 2007-06-23 at 11:19 -0700, Linus Torvalds wrote:
> > 
> > On Sat, 23 Jun 2007, Andrew Morton wrote:
> > > 
> > > Anyway.  Please fix the many correct warnings which checkpatch.pl
> > > generates
> > 
> > Actually, please don't.
> 
> You sure?  If I were to do this recommended fix, I would simply add
> another patch. One to do the fixes, the other to move the code. That way
> it should be trivial for something like git to recognize the code
> movement, since the code movement patch would be just that, move code,
> nothing else.  The clean up would be a separate change.
> 

If it's just code movement (I missed that fact) then I'd leave it be:
mucking with whitespace and stuff is unrelated to this work.

