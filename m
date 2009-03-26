Return-Path: <linux-kernel-owner+w=401wt.eu-S1757769AbZCZBpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769AbZCZBpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 21:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbZCZBpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 21:45:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753285AbZCZBpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 21:45:21 -0400
Date: Wed, 25 Mar 2009 18:36:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ric Wheeler <rwheeler@redhat.com>
cc: Jeff Garzik <jeff@garzik.org>, Theodore Tso <tytso@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <49CACC4A.2080600@redhat.com>
Message-ID: <alpine.LFD.2.00.0903251834470.3032@localhost.localdomain>
References: <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu> <alpine.LFD.2.00.0903241053200.3032@localhost.localdomain> <20090324184549.GE32307@mit.edu>
 <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk> <49CA9346.6040108@garzik.org> <alpine.LFD.2.00.0903251337410.3032@localhost.localdomain>
 <49CA9AD2.1080402@redhat.com> <alpine.LFD.2.00.0903251600310.3032@localhost.localdomain> <49CACC4A.2080600@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Mar 2009, Ric Wheeler wrote:
>
> In this case, you have not gained anything  - same number of barrier
> operations/cache flushes and looser semantics for the transactions?

Um. Except you gained the fact that the filesystem doesn't have to care 
and screw it up. And then we can know that it gets done, regardless of 
what odd things the low-level fs does.

		Linus
