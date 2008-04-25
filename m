Return-Path: <linux-kernel-owner+w=401wt.eu-S1764338AbYDYRAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764338AbYDYRAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 13:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762352AbYDYRAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 13:00:23 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:51123 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762232AbYDYRAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 13:00:23 -0400
Date: Fri, 25 Apr 2008 11:00:21 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Announce: Semaphore-Removal tree
Message-ID: <20080425170021.GH14990@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's been a Good Idea for a while to use mutexes instead of
semaphores where possible.  Additional debuggability, better optimised,
better-enforced semantics, etc.

Obviously, there are some places that can't be converted to mutexes.
I'm not proposing blind changes.  I've been through a dozen places
and found some that can be converted to spinlocks, others to
completions, but mostly to mutexes.  So as not to lose these patches,
I've made them available as a git tree.  I think the right way to get
these patches in will be to go through the maintainers of each file.

I'll post a list of the places using semaphores later.  My current list
is a bit out of date and contains insulting comments that I would like
to rephrase before the authors of the code in question see them ;-)

http://git.kernel.org/?p=linux/kernel/git/willy/misc.git;a=shortlog;h=semaphore-removal

Stephen, could you pick these patches up for linux-next?

git://git.kernel.org/pub/scm/linux/kernel/git/willy/misc.git semaphore-removal

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
