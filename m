Return-Path: <linux-kernel-owner+w=401wt.eu-S1757791AbZDNQ4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791AbZDNQ4P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbZDNQz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:55:56 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:53633 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbZDNQzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:55:55 -0400
Date: Tue, 14 Apr 2009 12:48:14 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, rusty@rustcorp.com.au,
       tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH UPDATED] percpu: use dynamic percpu allocator as the
 default percpu allocator
In-Reply-To: <20090414140416.GE27163@elte.hu>
Message-ID: <alpine.DEB.1.10.0904141233420.15948@qirst.com>
References: <20090401154913.GA31435@elte.hu> <alpine.DEB.1.10.0904011404240.29839@qirst.com> <20090401190113.GA734@elte.hu> <alpine.LFD.2.00.0904011235160.4130@localhost.localdomain> <20090401223241.GA28168@elte.hu> <alpine.DEB.1.10.0904012216370.32656@qirst.com>
 <20090402034223.GA25791@elte.hu> <alpine.DEB.1.10.0904020948570.31756@qirst.com> <20090408162651.GA14449@elte.hu> <alpine.DEB.1.10.0904131409510.13756@qirst.com> <20090414140416.GE27163@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Apr 2009, Ingo Molnar wrote:

> The thing is, i spent well in excess of an hour analyzing your
> patch, counting cachelines, looking at effects and interactions,
> thinking about the various implications. I came up with a good deal
> of factoids, a handful of suggestions and a few summary paragraphs:
>
>   http://marc.info/?l=linux-kernel&m=123862536011780&w=2

Good work.

> A proper reply to that work would be one of several responses:
>

...

>
>   3) agree with the factoids and disagree with my opinion.

Yep I thought that what I did...

> Furthermore, you also tried to 'win' this argument by increasing the
> volume of shouting, by injecting unprovoked insults and by using a
> patronizing and irritated tone.

Win an argument? I want to restore the function of __read_mostly to what
it was intended. It seems that you wanted instead to tag labels on all
sorts of variables in the kernel that show their usage pattern.

