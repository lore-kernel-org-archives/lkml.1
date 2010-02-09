Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab0BIRW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 12:22:28 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:39063 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899Ab0BIRW0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 12:22:26 -0500
MIME-Version: 1.0
In-Reply-To: <20100205205041.GA4178@oksana.dev.rtsoft.ru>
References: <20100205204949.GA2575@oksana.dev.rtsoft.ru> <20100205205041.GA4178@oksana.dev.rtsoft.ru>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 9 Feb 2010 10:22:04 -0700
X-Google-Sender-Auth: 4e845b9bc554d396
Message-ID: <fa686aa41002090922p73abf37bm2ae44823b9d0853@mail.gmail.com>
Subject: Re: [PATCH 1/3] of platforms: Move common static initialization to 
	of_node_init()
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, Michal Simek <monstr@monstr.eu>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       devicetree-discuss@lists.ozlabs.org, microblaze-uclinux@itee.uq.edu.au
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 5, 2010 at 1:50 PM, Anton Vorontsov
<avorontsov@ru.mvista.com> wrote:
> So far of_node_init() just initializes a kref, later we'll have to
> initialize other fields (for example node->data_lock).
>
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
>  arch/microblaze/kernel/prom.c             |    4 ++--
>  arch/powerpc/kernel/prom.c                |    4 ++--
>  arch/powerpc/platforms/iseries/vio.c      |    5 +++--
>  arch/powerpc/platforms/pseries/dlpar.c    |    7 ++++---
>  arch/powerpc/platforms/pseries/reconfig.c |    7 ++++---
>  arch/powerpc/sysdev/msi_bitmap.c          |    4 ++--
>  arch/sparc/kernel/prom_common.c           |    6 +++---
>  drivers/of/base.c                         |   10 ++++++++++
>  include/linux/of.h                        |    2 ++
>  9 files changed, 32 insertions(+), 17 deletions(-)

unflatten_dt_*() has been merged and moved to drivers/of.  Please
rebase this series on top of my next-devicetree branch in this git
tree:

git://git.secretlab.ca/git/linux-2.6

Otherwise, this looks fine to me.

g.
