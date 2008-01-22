Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbYAVV07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbYAVV07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 16:26:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbYAVV0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 16:26:49 -0500
Received: from yergi.telenet-ops.be ([195.130.132.36]:53689 "EHLO
	yergi.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbYAVV0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 16:26:47 -0500
Date: Tue, 22 Jan 2008 22:25:59 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Bryan Wu <bryan.wu@analog.com>, Mikael Starvik <starvik@axis.com>,
       David Howells <dhowells@redhat.com>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Kyle McMartin <kyle@parisc-linux.org>, Matthew Wilcox <matthew@wil.cx>,
       Chris Zankel <chris@zankel.net>
Subject: Re: [PATCH] procfs: constify function pointer tables
In-Reply-To: <Pine.LNX.4.64.0801222055440.5722@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0801222225320.29273@anakin>
References: <54038cd4f87a03884e4f59f8f3697889dfb63c54.1201030614.git.jengelh@computergmbh.de>
 <Pine.LNX.4.64.0801222055440.5722@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jan 2008, Jan Engelhardt wrote:
> This touches so many different places that I did not feel like creating 
> a miniscule patch for each architecture. I hope that is ok.
> 
> ===Patch begins===
> [PATCH] procfs: constify function pointer tables
> 
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> ---
>  arch/alpha/kernel/setup.c     |    2 +-
>  arch/blackfin/kernel/setup.c  |    2 +-
>  arch/cris/kernel/setup.c      |    2 +-
>  arch/frv/kernel/setup.c       |    2 +-
>  arch/h8300/kernel/setup.c     |    2 +-
>  arch/m32r/kernel/setup.c      |    2 +-
>  arch/m68k/kernel/setup.c      |    2 +-
>  arch/m68knommu/kernel/setup.c |    2 +-
>  arch/parisc/kernel/setup.c    |    2 +-
>  arch/ppc/kernel/setup.c       |    2 +-
>  arch/v850/kernel/procfs.c     |    2 +-
>  arch/xtensa/kernel/setup.c    |    2 +-
>  fs/proc/base.c                |    6 +++---
>  fs/proc/nommu.c               |    2 +-
>  fs/proc/proc_misc.c           |   22 +++++++++++-----------
>  fs/proc/proc_sysctl.c         |    4 ++--
>  fs/proc/proc_tty.c            |    2 +-
>  fs/proc/task_mmu.c            |    8 ++++----
>  fs/proc/task_nommu.c          |    2 +-
>  19 files changed, 35 insertions(+), 35 deletions(-)

m68k part is:

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
