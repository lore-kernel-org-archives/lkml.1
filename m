Return-Path: <linux-kernel-owner+w=401wt.eu-S1754380AbYGXTJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbYGXTJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 15:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbYGXTJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 15:09:21 -0400
Received: from iabervon.org ([66.92.72.58]:50154 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605AbYGXTJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 15:09:20 -0400
Date: Thu, 24 Jul 2008 15:09:18 -0400 (EDT)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Jack Howarth <howarth@bromo.msbb.uc.edu>
cc: linux-kernel@vger.kernel.org
Subject: Re: merging branches remotely with git?
In-Reply-To: <20080724173030.GA7609@bromo.msbb.uc.edu>
Message-ID: <alpine.LNX.1.00.0807241453470.19665@iabervon.org>
References: <20080724173030.GA7609@bromo.msbb.uc.edu>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2008, Jack Howarth wrote:

>     I am trying to do a local merge of the linus-kernel git and
> the my-wireless-testing git. Is this possible? I have cloned both
> locally with...
> 
> git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> git clone git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/my-wireless-testing.git
> 
> I thought from the git documentation that I was supposed to be able to
> create a merge automatically with...
> 
> git merge git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/my-wireless-testing.git
>
> however this reports...
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git - not something we can merge
> 
> Any advice on how this can be done would be appreciated.

In the my-wireless-testing directory:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

or:

git pull ../linux-2.6.git (which gets it from the other clone you made).

"git merge" is for merging branches you have (copies of) in the same 
repository. There's also "git fetch" for getting local copies of branches 
(and tags) elsewhere, and "git pull" does a "fetch" and a "merge", with 
the ability to put the information only in a temporary location in 
between.

What part of the documentation confused you? It probably needs to be 
clarified.

	-Daniel
*This .sig left intentionally blank*
