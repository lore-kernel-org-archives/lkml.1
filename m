Return-Path: <linux-kernel-owner+w=401wt.eu-S1758045AbZDEUBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045AbZDEUBl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 16:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbZDEUBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 16:01:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753528AbZDEUBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 16:01:32 -0400
Date: Sun, 5 Apr 2009 12:56:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [GIT PULL] SLAB include file dependency fixes + kmemtrace
 updates
In-Reply-To: <20090405193944.GA12691@elte.hu>
Message-ID: <alpine.LFD.2.00.0904051251390.4023@localhost.localdomain>
References: <20090405193944.GA12691@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 5 Apr 2009, Ingo Molnar wrote:
> 
> ( Please note that i rebased the tree exactly once, shortly after it 
>   got finished, to make it all bisectable and reviewable: the 
>   perfect insight shown in the tree now was IMHO not humanly 
>   possible to achieve in advance.

This is actually the rigth thing to do. Rebasing is not wrong, if it is 
done judiciously (and not on already-exposed stuff).

Rebasing is bad if
 - you do it so late in the game that all test experience is basically 
   worthless
 - after you've pushed out and other people have seen and depend on that 
   branch (and you didn't warn them)
 - you do it to other peoples git commits, so that their tree (that was 
   the source of the commit) now has the same commit duplicated as 
   something else.

I wrote a posting about rebasing to Dave Airlie on dri-devel, that might 
be googleable. Hmm. Here:

	http://www.mail-archive.com/dri-devel@lists.sourceforge.net/msg39091.html

so rebase isn't bad, it's often a great way to fix things as you go along. 
It just goes with a few basic caveats.

			Linus

