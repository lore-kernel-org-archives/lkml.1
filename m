Return-Path: <linux-kernel-owner+w=401wt.eu-S1751554AbZBCM7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbZBCM7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 07:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbZBCM7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 07:59:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54399 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbZBCM7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 07:59:06 -0500
Date: Tue, 3 Feb 2009 13:58:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Cc: x86 maintainers <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
       reiserfs-devel@vger.kernel.org
Subject: Re: [git pull -tip V2] fix headers_check warnings
Message-ID: <20090203125844.GI19979@elte.hu>
References: <1233598278.10133.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233598278.10133.4.camel@localhost.localdomain>
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

> 
> The following changes since commit 1ff8f739c7cc4eaa89b6ba986494f458ff7bdbef:
>   Jaswinder Singh Rajput (1):
>         headers_check fix: xtensa, swab.h
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tipclean.git core/header-fixes
> 
> Jaswinder Singh Rajput (7):
>       headers_check fix: linux/coda_psdev.h
>       headers_check fix: linux/in6.h
>       headers_check fix: linux/nubus.h
>       headers_check fix: linux/socket.h
>       headers_check fix: linux/reinserfs_fs.h
>       headers_check fix: x86, prctl.h
>       headers_check fix: x86, setup.h
> 
>  arch/x86/include/asm/prctl.h    |    4 ---
>  arch/x86/include/asm/setup.h    |   45 +++++++++++++++++++--------------------
>  arch/x86/include/asm/syscalls.h |    1 +
>  include/linux/coda_psdev.h      |   15 ++++++-------
>  include/linux/in6.h             |    2 +-
>  include/linux/nubus.h           |    2 +
>  include/linux/reiserfs_fs.h     |    8 +++++++
>  include/linux/socket.h          |    6 +++-
>  8 files changed, 45 insertions(+), 38 deletions(-)
> 
> This patchset fixes 31 headers_check warnings as shown earlier.

Pulled into tip/core/header-fixes, thanks Jaswinder.

I'll put this through the -tip testing machinery as the x86 bits have the 
potential to have build breakage side-effects.

	Ingo
