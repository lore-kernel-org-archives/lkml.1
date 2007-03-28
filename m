Return-Path: <linux-kernel-owner+w=401wt.eu-S932508AbXC1T1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508AbXC1T1G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 15:27:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933149AbXC1T1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 15:27:06 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:44745 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508AbXC1T1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 15:27:05 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 28 Mar 2007 12:26:57 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Nick Piggin <npiggin@suse.de>
cc: Ingo Molnar <mingo@elte.hu>, Nikita Danilov <nikita@clusterfs.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ravikiran G Thirumalai <kiran@scalex86.org>
Subject: Re: [rfc][patch] queued spinlocks (i386)
In-Reply-To: <20070328064318.GA12508@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0703281224030.21150@alien.or.mcafeemobile.com>
References: <20070323085910.GA11577@wotan.suse.de> <20070323100418.GA30740@elte.hu>
 <20070323103243.GE11577@wotan.suse.de> <17925.18904.820106.145029@gargle.gargle.HOWL>
 <20070324172959.GB542@elte.hu> <20070328064318.GA12508@wotan.suse.de>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2007, Nick Piggin wrote:

> On Sat, Mar 24, 2007 at 06:29:59PM +0100, Ingo Molnar wrote:
> > 
> > * Nikita Danilov <nikita@clusterfs.com> wrote:
> > 
> > > Indeed, this technique is very well known. E.g., 
> > > http://citeseer.ist.psu.edu/anderson01sharedmemory.html has a whole 
> > > section (3. Local-spin Algorithms) on them, citing papers from the 
> > > 1990 onward.
> > 
> > that is a cool reference! So i'd suggest to do (redo?) the patch based 
> > on those concepts and that terminology and not use 'queued spinlocks' 
> > that are commonly associated with MS's stuff. And as a result the 
> > contended case would be optimized some more via local-spin algorithms. 
> > (which is not a key thing for us, but which would be nice to have 
> > nevertheless)
> 
> Firstly, the terminology in that paper _is_ "queue lock", which isn't
> really surprising. I don't really know or care about what MS calls their
> locks, but I'd suggest that their queued spinlock is probably named in
> reference to its queueing property rather than its local spin property.

The method you propose is otherwise called "Ticket Lock":

http://en.wikipedia.org/wiki/Ticket_lock
http://www.cs.rochester.edu/research/synchronization/pseudocode/ss.html#ticket




- Davide


