Return-Path: <linux-kernel-owner+w=401wt.eu-S1759033AbZBMMwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759033AbZBMMwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 07:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbZBMMwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 07:52:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:43232 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266AbZBMMwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 07:52:16 -0500
Subject: Re: [git pull -tip V2] fix headers_check warnings
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "David S. Miller" <davem@davemloft.net>, x86 maintainers <x86@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org
In-Reply-To: <20090203125844.GI19979@elte.hu>
References: <1233598278.10133.4.camel@localhost.localdomain>
	 <20090203125844.GI19979@elte.hu>
Content-Type: text/plain
Date: Fri, 13 Feb 2009 18:21:07 +0530
Message-Id: <1234529467.23142.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-03 at 13:58 +0100, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > 
> > The following changes since commit 1ff8f739c7cc4eaa89b6ba986494f458ff7bdbef:
> >   Jaswinder Singh Rajput (1):
> >         headers_check fix: xtensa, swab.h
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tipclean.git core/header-fixes
> > 
> > Jaswinder Singh Rajput (7):
> >       headers_check fix: linux/coda_psdev.h
> >       headers_check fix: linux/in6.h
> >       headers_check fix: linux/nubus.h
> >       headers_check fix: linux/socket.h
> >       headers_check fix: linux/reinserfs_fs.h
> >       headers_check fix: x86, prctl.h
> >       headers_check fix: x86, setup.h
> > 
> >  arch/x86/include/asm/prctl.h    |    4 ---
> >  arch/x86/include/asm/setup.h    |   45 +++++++++++++++++++--------------------
> >  arch/x86/include/asm/syscalls.h |    1 +
> >  include/linux/coda_psdev.h      |   15 ++++++-------
> >  include/linux/in6.h             |    2 +-
> >  include/linux/nubus.h           |    2 +
> >  include/linux/reiserfs_fs.h     |    8 +++++++
> >  include/linux/socket.h          |    6 +++-
> >  8 files changed, 45 insertions(+), 38 deletions(-)
> > 
> > This patchset fixes 31 headers_check warnings as shown earlier.
> 
> Pulled into tip/core/header-fixes, thanks Jaswinder.
> 
> I'll put this through the -tip testing machinery as the x86 bits have the 
> potential to have build breakage side-effects.
> 


Regarding headers_check warnings whether anyone would like to see
anything beyond what's currently in -tip?

--
JSR

