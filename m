Return-Path: <linux-kernel-owner+w=401wt.eu-S1752633AbYJAEmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbYJAEmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 00:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750939AbYJAEmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 00:42:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:54888 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbYJAEmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 00:42:10 -0400
Date: Wed, 1 Oct 2008 00:42:08 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Pekka Paalanen <pq@iki.fi>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 6/6] ftrace: take advantage of variable length entries
In-Reply-To: <alpine.DEB.1.10.0809301341300.6224@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0810010040570.14807@gandalf.stny.rr.com>
References: <20080930030236.230994826@goodmis.org> <20080930030652.883661046@goodmis.org> <20080930203342.5b5ca814@daedalus.pq.iki.fi> <alpine.DEB.1.10.0809301341300.6224@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 30 Sep 2008, Steven Rostedt wrote:
> > On the mmiotrace part, I don't see anything wrong here apart
> > from that one bug.
> 
> Thanks, I'll add a patch to my coming queue to handle this.

Bah, I lied. The new locking design took a bit more time to do than 
I expected, and I forgot to add this fix. I'll add it tomorrow.

Thanks,

-- Steve

