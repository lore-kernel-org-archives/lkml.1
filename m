Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbYEQRFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbYEQRFj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 13:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbYEQRF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 13:05:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751258AbYEQRF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 13:05:27 -0400
Date: Sat, 17 May 2008 10:05:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Theodore Tso <tytso@mit.edu>
cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT pull] x86 fixes for 2.6.26
In-Reply-To: <20080517145802.GB6978@mit.edu>
Message-ID: <alpine.LFD.1.10.0805170944000.3020@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805170037180.3255@apollo.tec.linutronix.de> <alpine.LFD.1.10.0805161544080.3020@woody.linux-foundation.org> <20080517015705.GA20375@mit.edu> <alpine.LFD.1.10.0805161933240.3020@woody.linux-foundation.org>
 <20080517145802.GB6978@mit.edu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 17 May 2008, Theodore Tso wrote:
> 
> Right, but so long as a subsystem maintainer doesn't publish his/her
> topic branches, and only sends out patches on their topic branches for
> discussion via e-mail, they're fine, right?

Yes. But then you really cannot work with other people with git.

That's what i was saying - you can use "git rebase" as long as you're a 
"leaf developer" from a git standpoint, and everything you do is just 
emailing patches around. 

And quite frankly, if the x86 maintainer is a "leaf developer", we are 
going to be in trouble in the long run. Unless some other architecture 
comes out an takes away all the users and developers (which obviously 
isn't going to happen).

> Basically, this would be the subsystem maintainer sometimes wearing an
> "end-point-developer" hat, and sometimes wearing a "subsystem
> maintainer" hat.  So rebasing is fine as long as it's clear that it's
> happening on branches which are not meant as a base for
> submaintainers.  

It's not about "not meant as a base". It's about "cannot *possibly* be a 
base". And the difference is that while *you* may not want others to base 
their work off it, are you sure others agree?

And realize that while "git rebase" may be making things easier for the 
person that does the rebase, what it ends up doing for *others* is to take 
away options from them, and making for more work for them.

Again, if there are not enough others to matter, then you _should_ make 
the workflow be around your own personal sandbox. So 'git rebase' makes 
sense then.

Basically, it boils down to whether you're a technical manager or a grunt. 

A grunt should use 'git rebase' to keep his own work in line. A technical 
manager, while he hopefully does some useful work on his own, should 
strive to make _others_ do as much work as possible, and then 'git rebase' 
is the wrong thing, because it will always make it harder for the people 
around you to track your tree and to help you update your tree.

And it's absolutely true that Ingo has been a 'grunt' in many ways. Not 
only does everybody start out that way, but if you ask the question "who 
does the actual work" (as a way to find out who is not a manager, because 
managers by definition are useless bloodsucking parasites), then Ingo 
clearly doesn't look very managerial.

But I definitely think we want Ingo and Thomas to be managers, not grunts. 

Yes, both Ingo and Thomas are the top committers when looked at 
individually. Here's the top five committers since 2.6.24 in arch/x86:

	Ingo Molnar (194):
	Thomas Gleixner (125):
	Glauber de Oliveira Costa (117):
	Roland McGrath (103):
	Glauber Costa (92):
	...

and in that sense they look very much non-managerial. But those ~200 
commits are still just two hundred out of 1900 commits total! We *need* 
managers, not just grunts. And I can well imagine how stressful it is to 
not just do the two hundred commits, but also try to orchestrate the other 
~1700 ones.

			Linus
