Return-Path: <linux-kernel-owner+w=401wt.eu-S1757685AbZAIV02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685AbZAIV02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 16:26:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755862AbZAIV0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 16:26:17 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:42420 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339AbZAIV0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:26:16 -0500
Date: Fri, 9 Jan 2009 22:27:57 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org,
       Linux Power Management List <linux-pm@lists.osdl.org>
Subject: Re: git mv (was Re: [git pull] ACPI & Suspend patches for 2.6.29-rc0)
Message-ID: <20090109212757.GA25434@uranus.ravnborg.org>
References: <alpine.LFD.2.00.0901090550590.4091@localhost.localdomain> <alpine.LFD.2.00.0901091200150.6528@localhost.localdomain> <alpine.LFD.2.00.0901091537530.16697@localhost.localdomain> <alpine.LFD.2.00.0901091305160.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901091305160.6528@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> So yeah, "--follow" is broken. It's really a quick hack there for people 
> who come from some other SCM to feel more comfy with git. If you come from 
> SVN or CVS, you never had proper history, and you never had "gitk" anyway, 
> and so "gitk --follow" doesn't really work. But it makes the pure 
> _textual_ logs look a bit like CVS/SVN.
> 
> I'd love to make --follow work better and integrate more, but I've been so 
> successful at never using it myself that I don't much care. And it really 
> is not a very natural thing for git to do, so the hackiness is somewhat 
> inherent.

What other ways exist so I can see what the heck davem did to
arch/sparc64/kernel/irq.c then?

I know he added IRQ stacks - but how did the patch look like?
I know no other way to find the old history than to do:

    git log --follow arch/sparc/kernel/irq_64.c

But this also give me what I want. I'm just curious if there is
a better way - in the case where you know the old name.


	Sam
