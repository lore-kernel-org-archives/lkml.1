Return-Path: <linux-kernel-owner+w=401wt.eu-S1751884AbZAZMvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbZAZMvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 07:51:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbZAZMvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 07:51:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40109 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbZAZMvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 07:51:15 -0500
Date: Mon, 26 Jan 2009 13:50:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: x86 maintainers <x86@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       "H. Peter Anvin" <hpa@zytor.com>, jirislaby@gmail.com, gregkh@suse.de,
       David Miller <davem@davemloft.net>, Trent Piepho <xyzzy@speakeasy.org>,
       Arnd Bergmann <arnd@arndb.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       linux-media <linux-media@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL -tip] fix 22 make headers_check - 200901
Message-ID: <20090126125050.GB5812@elte.hu>
References: <1232801817.3125.21.camel@localhost.localdomain> <1232804587.17900.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232804587.17900.8.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Sat, 2009-01-24 at 18:26 +0530, Jaswinder Singh Rajput wrote:
> > The following changes since commit aa52dcf69565512e7d285c1c40dc6e56aab6f789:
> >   Ingo Molnar (1):
> >         Merge branch 'x86/urgent'
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git master
> > 
> > Jaswinder Singh Rajput (11):
> >       headers_check fix: linux/dvb/audio.h
> >       headers_check fix: linux/acct.h
> >       headers_check fix: linux/elf.h
> >       headers_check fix: linux/flat.h
> >       headers_check fix: linux/hid.h
> >       headers_check fix: linux/if_frad.h
> 
> 'headers_check fix: linux/if_frad.h' is dropped because of some issues.
> So here is new pull request:
> 
> The following changes since commit aa52dcf69565512e7d285c1c40dc6e56aab6f789:
>   Ingo Molnar (1):
>         Merge branch 'x86/urgent'
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git master
> 
> Jaswinder Singh Rajput (10):
>       headers_check fix: linux/dvb/audio.h
>       headers_check fix: linux/acct.h
>       headers_check fix: linux/elf.h
>       headers_check fix: linux/flat.h
>       headers_check fix: linux/hid.h
>       headers_check fix: linux/types.h
>       headers_check fix: linux/videodev.h
>       headers_check fix: x86, kvm.h
>       headers_check fix: x86, swab.h
>       headers_check fix: video/edid.h
> 
>  arch/x86/include/asm/kvm.h  |    2 +-
>  arch/x86/include/asm/swab.h |   12 +++++++++---
>  include/linux/acct.h        |    2 +-
>  include/linux/dvb/audio.h   |    5 -----
>  include/linux/elf.h         |    3 ++-
>  include/linux/flat.h        |    6 +++---
>  include/linux/hid.h         |    2 ++
>  include/linux/types.h       |    2 ++
>  include/linux/videodev.h    |   10 ++++++++--
>  include/video/edid.h        |    2 +-
>  10 files changed, 29 insertions(+), 17 deletions(-)

Pulled into tip/core/header-fixes, thanks Jaswinder!

	Ingo
