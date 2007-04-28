Return-Path: <linux-kernel-owner+w=401wt.eu-S1754423AbXD1Xkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423AbXD1Xkx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 19:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754425AbXD1Xkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 19:40:53 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53847 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754419AbXD1Xkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 19:40:51 -0400
Date: Sat, 28 Apr 2007 16:40:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Markus Rechberger <mrechberger@gmail.com>
cc: Adrian Bunk <bunk@stusta.de>, Diego Calleja <diegocg@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
In-Reply-To: <d9def9db0704281558r57460a6ft76bbddcc480058eb@mail.gmail.com>
Message-ID: <alpine.LFD.0.98.0704281629440.9964@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org>
  <20070426125802.GL3468@stusta.de>  <alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org>
  <4630DB24.4030005@redhat.com>  <20070426201325.8a1ebda3.diegocg@gmail.com>
  <alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org> 
 <20070426224148.69b91b2e.diegocg@gmail.com> 
 <alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org> 
 <20070428195320.GZ3468@stusta.de>  <alpine.LFD.0.98.0704281529080.9964@woody.linux-foundation.org>
 <d9def9db0704281558r57460a6ft76bbddcc480058eb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 29 Apr 2007, Markus Rechberger wrote:
> 
> I totally disagree here, bugzilla is a very good tool. If someone is
> too lazy to look at it it's his problem.

You must be doing things very differently from a lot of other people if 
you think that's the case.

> Kernel Janitors can pick out some bugs which aren't addressed by
> anyone or got left behind.

IF that happened, it would actually be great. That's what I'm arguing for. 
And it was basically what Adrian was doing!

> How else should bugs get handled, sending them to the lkml?

Actually, looking at Adrian's regression lists, yes. lkml worked better 
than bugzilla did. By at _least_ a factor of two.

> I'm 100% sure some bugreports will also get lost then, but on the lkml
> they'll very likely remain lost whereas in the bugzilla they'll remain
> as open.

What's the difference between bugzilla and lkml.org? Both have search 
buttons. Both archive the old stuff. Both can be pointed to.

> what are your suggestions to improve a bugreporting tool, I'm very
> sure that many people, especially people who want to get into existing
> projects here, would love to contribute.

I don't know what the perfect setup is, but I do know that bugzilla is 
very close to be totally useless for the top-level maintainers.

Try to think like a person who doesn't maintain *one* specific file in the 
kernel, but who can actually make a good judgement about a lot of things, 
or at least funnel a problem report to the right person?

And now, imagine that that person is also fairly busy (exactly *because* 
he's not looking at a single file, he may be maintaining a huge subsystem 
that has multiple submaintainers etc).

And ask yourself whether bugzilla really helps.

> I'd say this is a personal opinion, some people will get along with it
> and some of them will not...

I think bugzilla really only works for very "directed" issues. If you 
already know exactly which driver is affected (which is often wrong 
anyway: some of the bugs that were due timer breakage got blamed as disk 
hangs!) it's almost totally useless.

And yes, maybe that's why you have a much higher opinion of bugzilla than 
I do. To _me_ bugzilla is a total mess. There's absolutely _zero_ useful 
information there. And I'm pretty certain that is true of a *lot* of other 
people too. But if you have a small project, or you maintain a very 
specific (and clearly delineated) part of a big project, bugzilla probably 
looks a lot more palatable.

			Linus
