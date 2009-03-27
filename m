Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbZC0Vy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbZC0Vy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 17:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbZC0VyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 17:54:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38624 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752052AbZC0VyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 17:54:19 -0400
Date: Fri, 27 Mar 2009 14:52:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jan Kara <jack@suse.cz>
cc: tytso@mit.edu, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PULL REQUEST] Quota changes for 2.6.30
In-Reply-To: <20090327201227.GA31071@duck.suse.cz>
Message-ID: <alpine.LFD.2.00.0903271448520.3994@localhost.localdomain>
References: <20090326012207.GG11024@duck.suse.cz> <alpine.LFD.2.00.0903261616210.3032@localhost.localdomain> <20090327201227.GA31071@duck.suse.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Mar 2009, Jan Kara wrote:

> On Thu 26-03-09 16:16:47, Linus Torvalds wrote:
> > 
> > 
> > On Thu, 26 Mar 2009, Jan Kara wrote:
> > > 
> > >   could you please pull from
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-quota-2.6.git for_linus
> > 
> > 	"Already up-to-date."
> > 
> > Forgot to actually push it out?
>   Damn, you're right. Should be there now.

It is, but now when I pull I notice that you hadn't used "-M --summary" 
when asking me to pull. You claimed:

	 66 files changed, 4770 insertions(+), 4565 deletions(-)

but in fact it's really:

	 58 files changed, 902 insertions(+), 697 deletions(-)
	 create mode 100644 fs/quota/Kconfig
	 create mode 100644 fs/quota/Makefile
	 rename fs/{ => quota}/dquot.c (85%)
	 rename fs/{ => quota}/quota.c (94%)
	 rename fs/{ => quota}/quota_tree.c (84%)
	 rename fs/{ => quota}/quota_tree.h (100%)
	 rename fs/{ => quota}/quota_v1.c (79%)
	 rename fs/{ => quota}/quota_v2.c (98%)
	 rename fs/{ => quota}/quotaio_v1.h (100%)
	 rename fs/{ => quota}/quotaio_v2.h (100%)

so please do change your pull-request script to add -M (for rename 
detection) and --summary (for that "new, deleted and renamed files" 
summary at the end).

It really does generate a much nicer view of what changed, _especially_ in 
cases like the above when a non-rename patch is mostly movement noise.

Git still defaults to non-rename patches because some people probably 
still use inferior crud that doesn't understand about the extended patch 
semantics of git patches.

			Linus
