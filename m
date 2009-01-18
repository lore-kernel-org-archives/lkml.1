Return-Path: <linux-kernel-owner+w=401wt.eu-S934276AbZARR2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934276AbZARR2b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 12:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764139AbZARR2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 12:28:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49901 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762473AbZARR2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 12:28:21 -0500
Date: Sun, 18 Jan 2009 18:28:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL -tip v3] fix 39 'make headers_check' warnings
Message-ID: <20090118172800.GB22624@elte.hu>
References: <1232287474.3130.19.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232287474.3130.19.camel@localhost.localdomain>
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

> The following changes since commit 2a927058df624d1c19bd42a90cb91ae148f12651:
>   Ingo Molnar (1):
>         Merge branch 'core/header-fixes'
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tiptop.git master
> 
> Jaswinder Singh Rajput (14):
>       headers_check fix: linux/atmdev.h
>       headers_check fix: linux/cm4000_cs.h
>       headers_check fix: linux/elf-fdpic.h
>       headers_check fix: linux/elfcore.h
>       headers_check fix: linux/fb.h
>       headers_check fix: linux/flat.h
>       headers_check fix: linux/kernel.h
>       headers_check fix: linux/kvm.h
>       headers_check fix: linux/pkt_cls.h
>       headers_check fix: linux/pktcdvd.h
>       headers_check fix: linux/raw.h
>       headers_check fix: linux/socket.h
>       headers_check fix: linux/sound.h
>       headers_check fix: linux/videodev2.h
> 
>  include/linux/atmdev.h    |    2 ++
>  include/linux/cm4000_cs.h |    2 +-
>  include/linux/elf-fdpic.h |    2 ++
>  include/linux/elfcore.h   |    2 ++
>  include/linux/fb.h        |    4 ++--
>  include/linux/flat.h      |    8 +++++---
>  include/linux/kernel.h    |    3 ++-
>  include/linux/kvm.h       |    8 ++++++++
>  include/linux/pkt_cls.h   |    4 ++--
>  include/linux/pktcdvd.h   |    2 ++
>  include/linux/raw.h       |    2 ++
>  include/linux/socket.h    |    3 ++-
>  include/linux/sound.h     |    2 ++
>  include/linux/videodev2.h |    2 +-
>  14 files changed, 35 insertions(+), 11 deletions(-)
> 
> This patchset fix the following 'make headers_check' warnings:
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/atmdev.h:103: leaks CONFIG_COMPAT to userspace where it is not valid
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/cm4000_cs.h:22: leaks CONFIG_COMPAT to userspace where it is not valid
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/elf-fdpic.h:61: leaks CONFIG_MMU to userspace where it is not valid
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/elf-fdpic.h:62: extern's make no sense in userspace
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/elfcore.h:59: leaks CONFIG_BINFMT to userspace where it is not valid
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/fb.h:4: include of <linux/types.h> is preferred over <asm/types.h>
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/fb.h:152: found __[us]{8,16,32,64} type without #include <linux/types.h>
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/fb.h:381: leaks CONFIG_FB to userspace where it is not valid
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/flat.h:16: leaks CONFIG_BINFMT to userspace where it is not valid
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/kernel.h:39: leaks CONFIG_NUMA to userspace where it is not valid
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/kernel.h:40: leaks CONFIG_NUMA to userspace where it is not valid
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/kernel.h:46: leaks CONFIG_FTRACE to userspace where it is not valid
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/kernel.h:47: leaks CONFIG_FTRACE to userspace where it is not valid
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/kvm.h:10: include of <linux/types.h> is preferred over <asm/types.h>
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/kvm.h:19: found __[us]{8,16,32,64} type without #include <linux/types.h>
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/kvm.h:61: leaks CONFIG_X86 to userspace where it is not valid
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/kvm.h:64: leaks CONFIG_X86 to userspace where it is not valid
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/kvm.h:387: leaks CONFIG_X86 to userspace where it is not valid
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/kvm.h:391: leaks CONFIG_X86 to userspace where it is not valid
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/kvm.h:396: leaks CONFIG_X86 to userspace where it is not valid
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/pkt_cls.h:122: found __[us]{8,16,32,64} type without #include <linux/types.h>
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/pkt_cls.h:306: leaks CONFIG_NET to userspace where it is not valid
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/pkt_cls.h:307: leaks CONFIG_NET to userspace where it is not valid
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/pktcdvd.h:36: leaks CONFIG_CDROM to userspace where it is not valid
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/ppp_defs.h:50: found __[us]{8,16,32,64} type without #include <linux/types.h>
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/raw.h:16: leaks CONFIG_MAX to userspace where it is not valid
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/socket.h:27: leaks CONFIG_PROC to userspace where it is not valid
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/socket.h:29: extern's make no sense in userspace
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/socket.h:262: leaks CONFIG_COMPAT to userspace where it is not valid
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/sound.h:33: extern's make no sense in userspace
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/sound.h:34: extern's make no sense in userspace
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/sound.h:35: extern's make no sense in userspace
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/sound.h:36: extern's make no sense in userspace
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/sound.h:37: extern's make no sense in userspace
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/sound.h:39: extern's make no sense in userspace
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/sound.h:40: extern's make no sense in userspace
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/sound.h:41: extern's make no sense in userspace
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/sound.h:42: extern's make no sense in userspace
> /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/videodev2.h:1477: leaks CONFIG_VIDEO to userspace where it is not valid

pulled into tip/core/header-fixes, thanks Jaswinder!

	Ingo
