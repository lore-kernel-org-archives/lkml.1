Return-Path: <linux-kernel-owner+w=401wt.eu-S1763095AbZE0Hbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763095AbZE0Hbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762395AbZE0H0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:26:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47528 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761539AbZE0H0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:26:52 -0400
Date: Wed, 27 May 2009 09:26:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] kmemcheck fixes for -tip
Message-ID: <20090527072643.GA15000@elte.hu>
References: <20090527054317.GA31443@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527054317.GA31443@damson.getinternet.no>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> Hi,
> 
> These are the patches I posted to LKML a while ago. Full diff included.
> 
> With this, we should be able to resume linux-next integration. It also gets
> rid of the two most frequent false positives, so automatic testing should be
> more useful.
> 
> The following changes since commit 12d77a12affc8310e09598fb5a35605549eb9730:
>   Ingo Molnar (1):
>         Merge commit 'v2.6.30-rc5' into kmemcheck
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/vegard/kmemcheck.git for-tip
> 
> Vegard Nossum (5):
>       kmemcheck: make bitfield annotations be valid C
>       fs: introduce __getname_gfp()
>       kmemcheck: add __GFP_NOTRACK_FALSE_POSITIVE flag
>       kmemcheck: fix do_mount_root() false positive
>       kmemcheck: fix __send_signal() false positive
>
>  drivers/ieee1394/csr1212.c       |    2 +-
>  drivers/ieee1394/nodemgr.c       |    8 ++--
>  drivers/misc/c2port/core.c       |    2 +-
>  include/linux/c2port.h           |    8 ++--
>  include/linux/fs.h               |    5 +-
>  include/linux/gfp.h              |    6 +++
>  include/linux/kmemcheck.h        |   91 +++++++++++++++++++------------------
>  include/linux/ring_buffer.h      |    6 +-
>  include/linux/skbuff.h           |   34 +++++++-------
>  include/net/inet_sock.h          |   22 +++++-----
>  include/net/inet_timewait_sock.h |   12 +++---
>  include/net/sock.h               |   10 ++--
>  init/do_mounts.c                 |    3 +-
>  kernel/signal.c                  |   11 +++-
>  kernel/trace/ring_buffer.c       |    4 +-
>  net/core/skbuff.c                |   12 +++---
>  net/core/sock.c                  |    2 +-
>  net/ipv4/inet_timewait_sock.c    |    2 +-
>  18 files changed, 128 insertions(+), 112 deletions(-)

Pulled, thanks Vegard! There were a few conflicts with tip:master, 
due to ongoing work in other areas:

    Merge branch 'kmemcheck'
    
    Conflicts:
        include/linux/ring_buffer.h
        init/do_mounts.c
        kernel/trace/ring_buffer.c

I resolved them manually, you might want to double check them.

	Ingo
