Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab0CFV1H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 16:27:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43901 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751311Ab0CFV1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 16:27:03 -0500
Date: Sat, 6 Mar 2010 13:26:46 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: =?ISO-8859-15?Q?J=F6rn_Engel?= <joern@logfs.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Please pull logfs tree
In-Reply-To: <20100306210459.GA21570@logfs.org>
Message-ID: <alpine.LFD.2.00.1003061319530.31447@localhost.localdomain>
References: <20100306210459.GA21570@logfs.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 6 Mar 2010, Jörn Engel wrote:
> 
> 1) pull git://git.kernel.org/pub/scm/linux/kernel/git/joern/logfs.git
> and apply the patch at the bottom yourself.

Not quite - it needs to be applied while merging, rather than applied 
separately. It's a conflict, even though it's not a data-conflict, but a 
semantic one.

But that's trivial enough. "git pull --no-commit" + fixup + "git commit" 
is trivially done, now that I was fore-warned. Thanks.

> 2) pull git://git.kernel.org/pub/scm/linux/kernel/git/joern/logfs_for_2.6.34
> A tree with the patch applied that won't work standalone but will work
> after being pulled into your tree (tested locally).

No, that's horrible. Unbisectable. Not that anybody probably cares in this 
case, but it's fundamentally wrong to merge something that doesn't work 
before the merge.

> 3) pull git://git.kernel.org/pub/scm/linux/kernel/git/joern/logfs_for_2.6.34_alternative
> A tree that merged your tree and the logfs tree, then has the patch
> applied.  Works standalone but has an additional merge commit.

That's ok, but I already did the trivial merge, which actually had another 
conflict too (which showed up as a real data conflict on the Kconfig 
file).

		Linus
