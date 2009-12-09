Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbZLITUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbZLITUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 14:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757064AbZLITUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 14:20:34 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:53691 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757026AbZLITUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 14:20:34 -0500
Date: Wed, 9 Dec 2009 20:20:38 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Michal Marek <mmarek@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [GIT PULL] kbuild updates for 2.6.33
Message-ID: <20091209192038.GA7827@merkur.ravnborg.org>
References: <20091208133004.GA22750@sepie.suse.cz> <20091209093349.GA11837@sepie.suse.cz> <20091209093108.387b2736.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091209093108.387b2736.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09, 2009 at 09:31:08AM -0800, Randy Dunlap wrote:
> On Wed, 9 Dec 2009 10:33:49 +0100 Michal Marek wrote:
> 
> > On Tue, Dec 08, 2009 at 02:30:04PM +0100, Michal Marek wrote:
> > > Hi Linus,
> > > 
> > > these are the kbuild patches I collected for 2.6.33. There might be a few
> > > more later, but this is the main part.
> > > 
> > > Thanks,
> > > Michal
> > > 
> > > The following changes since commit 6ec22f9b037fc0c2e00ddb7023fad279c365324d:
> > >   Linus Torvalds (1):
> > >         Merge branch 'x86-debug-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip
> > > 
> > > are available in the git repository at:
> > > 
> > >   git://repo.or.cz/linux-kbuild.git for-next
> > 
> > Hi Linus,
> > 
> > The kbuild tree now breaks with 250cce26 ("iwlwifi: driver version
> > track kernel version") which you merged yesterday. Stephen Rothwell
> > kindly provided a fix, which I would normally apply to the kbuild tree,
> > but I don't want to rebase it as I already sent the pull request. Could
> > you please apply the following one-liner when merging the kbuild tree?
> > Thanks!
> 
> Hi > Michal,
> 
> Is there anything that tells us when we should/must use
> <generated/*.h> ?

The original idea was that include/generated/ should
be used for all generated header files.

I once had a patch applied that used it for other
generated files - this was a bad idea. Said patch
was reverted as it had much bigger issues.

So think of it as a place for generated header files only.
This also warrants the location in include/

But only for 'global' header files. For drivers
and the like that needs the header file only locally the
header file should not be located n include/generated,
as it is only for the global headers.

asm-offsets.h is a good example here.

	Sam
