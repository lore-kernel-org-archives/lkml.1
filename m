Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab0CHXWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 18:22:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38014 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750972Ab0CHXVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 18:21:55 -0500
Date: Mon, 8 Mar 2010 15:21:04 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Eric Paris <eparis@parisplace.org>
cc: Ulrich Drepper <drepper@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ingo Molnar <mingo@elte.hu>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: Upstream first policy
In-Reply-To: <7e0fb38c1003081512j36b4fbbfpa5f93f988495f621@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1003081516300.3669@localhost.localdomain>
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org>  <20100308094647.GA14268@elte.hu>  <20100308173008.7ae389ab@lxorguk.ukuu.org.uk>  <alpine.LFD.2.00.1003080948060.3989@localhost.localdomain>  <a36005b51003081412u536c34cbu46b5288e32c73397@mail.gmail.com>
 <7e0fb38c1003081512j36b4fbbfpa5f93f988495f621@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 8 Mar 2010, Eric Paris wrote:
>
> answering a different post in the same email: I accept "THERE ARE
> DIFFERENT CASES."  You go on to say "So I'm not suggesting we
> _replace_ content-based security with pathname-based security. I'm
> just saying that pathnames actually do matter for security, and that
> they are an independent issue."  But what you are suggesting is
> EXACTLY that our users should _replace_ content-based security with
> pathname-based security when they have to boot with security=TOMOYO
> instead of security=SMACK.

No.

Because we already _have_ content-based security. The traditional UNIX 
model is all about "labeling", ie the inode-based security.

The fact that the extended security is then using something else in Tomoyo 
or AppArmor doesn't remove the traditional security model.

Again, your whole email is just "assuming" that selinux is the thing to 
be. No logic to your post at all. If you are using a AppArmor-based thing, 
you're not "switching" from SELinux to AppArmor. You're just using it.

Get it? The Ubuntu people seem to be happy with AppArmor. Deal with it. 
SELinux isn't the end-all and be-all of everything.

			Linus
