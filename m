Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbXFWTbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbXFWTbU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 15:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755022AbXFWTbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 15:31:13 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:32795 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbXFWTbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 15:31:12 -0400
Subject: Re: [RFC PATCH 5/5 v2] Convert tasklets to work queues
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, hch@infradead.org,
       johnstul@us.ibm.com, oleg@tv-sign.ru, paulmck@linux.vnet.ibm.com,
       dipankar@in.ibm.com, davem@davemloft.net, kuznet@ms2.inr.ac.ru
In-Reply-To: <alpine.LFD.0.98.0706231113200.3593@woody.linux-foundation.org>
References: <20070622182051.859570787@goodmis.org>
	 <20070622182315.571740041@goodmis.org>
	 <20070623095359.4667514e.akpm@linux-foundation.org>
	 <alpine.LFD.0.98.0706231113200.3593@woody.linux-foundation.org>
Content-Type: text/plain
Date: Sat, 23 Jun 2007 15:27:49 -0400
Message-Id: <1182626869.5493.143.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-23 at 11:19 -0700, Linus Torvalds wrote:
> 
> On Sat, 23 Jun 2007, Andrew Morton wrote:
> > 
> > Anyway.  Please fix the many correct warnings which checkpatch.pl
> > generates
> 
> Actually, please don't.

You sure?  If I were to do this recommended fix, I would simply add
another patch. One to do the fixes, the other to move the code. That way
it should be trivial for something like git to recognize the code
movement, since the code movement patch would be just that, move code,
nothing else.  The clean up would be a separate change.

-- Steve


