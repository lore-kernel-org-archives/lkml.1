Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab0CFVfO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 16:35:14 -0500
Received: from lazybastard.de ([212.112.238.170]:55351 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab0CFVfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 16:35:13 -0500
X-Greylist: delayed 1798 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Mar 2010 16:35:13 EST
Date: Sat, 6 Mar 2010 22:35:01 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Please pull logfs tree
Message-ID: <20100306213501.GB21570@logfs.org>
References: <20100306210459.GA21570@logfs.org> <alpine.LFD.2.00.1003061319530.31447@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.1003061319530.31447@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 March 2010 13:26:46 -0800, Linus Torvalds wrote:
> On Sat, 6 Mar 2010, Jörn Engel wrote:
> > 
> > 1) pull git://git.kernel.org/pub/scm/linux/kernel/git/joern/logfs.git
> > and apply the patch at the bottom yourself.
> 
> Not quite - it needs to be applied while merging, rather than applied 
> separately. It's a conflict, even though it's not a data-conflict, but a 
> semantic one.
> 
> But that's trivial enough. "git pull --no-commit" + fixup + "git commit" 
> is trivially done, now that I was fore-warned. Thanks.
> 
> > 2) pull git://git.kernel.org/pub/scm/linux/kernel/git/joern/logfs_for_2.6.34
> > A tree with the patch applied that won't work standalone but will work
> > after being pulled into your tree (tested locally).
> 
> No, that's horrible. Unbisectable. Not that anybody probably cares in this 
> case, but it's fundamentally wrong to merge something that doesn't work 
> before the merge.
> 
> > 3) pull git://git.kernel.org/pub/scm/linux/kernel/git/joern/logfs_for_2.6.34_alternative
> > A tree that merged your tree and the logfs tree, then has the patch
> > applied.  Works standalone but has an additional merge commit.
> 
> That's ok, but I already did the trivial merge, which actually had another 
> conflict too (which showed up as a real data conflict on the Kconfig 
> file).

Ok, learned something new again.  Thank you for doing the trivial merge
that would have taken me days to figure out. :)

Jörn

-- 
Beware of bugs in the above code; I have only proved it correct, but
not tried it.
-- Donald Knuth
