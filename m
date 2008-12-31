Return-Path: <linux-kernel-owner+w=401wt.eu-S1757047AbYLaRml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047AbYLaRml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 12:42:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756147AbYLaRmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 12:42:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756130AbYLaRma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 12:42:30 -0500
Date: Wed, 31 Dec 2008 09:41:59 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: [git pull] vfs patches, part 1
In-Reply-To: <alpine.LFD.2.00.0812310905580.5086@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0812310935080.5086@localhost.localdomain>
References: <20081231074356.GA28946@ZenIV.linux.org.uk> <alpine.LFD.2.00.0812310905580.5086@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 31 Dec 2008, Linus Torvalds wrote:
> 
> I pulled it, but after looking at it, I unpulled it again. It really is 
> every single commit that is broken.

Btw, I can re-pull and just do a rebase and fix things up by hand myself, 
so if you don't want to, I can clean up this sequence myself. But I just 
don't want it to become a habit, so I want to make sure that at least in 
the future these things won't look as horrible.

In case you wonder what the easiest way to fix things up is: just export 
the series as a mbox ("git log -p --stat --pretty=email linus.. > mbox") 
and then just edit the single mbox file to remove crud. Then you can 
re-apply it with "git am".

Of course, with git you can do it in a million different ways: You could 
do it with "git format-patch" or with "git rebase -i" too, for example, 
but exporting it as an mbox means that you can do it in one single editing 
session, which is how at least I personally work. Much nicer than having 
to handle each commit individually.

		Linus
