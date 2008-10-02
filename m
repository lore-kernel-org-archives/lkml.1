Return-Path: <linux-kernel-owner+w=401wt.eu-S1753210AbYJBFJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbYJBFJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 01:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751807AbYJBFJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 01:09:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57067 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbYJBFJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 01:09:05 -0400
Date: Thu, 2 Oct 2008 01:09:03 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jon Masters <jonathan@jonmasters.org>
cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Sven Dietrich <sdietrich@suse.de>
Subject: Re: [RFC patch 2/5] genirq: add a quick check handler
In-Reply-To: <1222908459.31183.73.camel@perihelion.int.jonmasters.org>
Message-ID: <alpine.DEB.1.10.0810020107210.11373@gandalf.stny.rr.com>
References: <20081001223213.078984344@linutronix.de>  <20081001223301.900862899@linutronix.de> <1222908459.31183.73.camel@perihelion.int.jonmasters.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 1 Oct 2008, Jon Masters wrote:
> 
> We probably need some documentation eventually so people realize what
> this "quickcheck" handler is for and what it's not for - under no
> circumstances should anything more than the bare minimum be done.
> Otherwise it breaks the benefit of deferred threaded handling. It's hard
> to enforce that - but this is *not* a return of top/bottom half handling
> where you can do whatever crap you like in the quickcheck bit.
> 

We could always implement something similar to what I was told Microsoft 
does (I was just told this, I don't know for fact). Time this function and 
if it takes longer than, say 50us, print a warning and kill the device
;-)

-- Steve

