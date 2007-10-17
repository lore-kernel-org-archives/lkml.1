Return-Path: <linux-kernel-owner+w=401wt.eu-S933304AbXJQUs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933304AbXJQUs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758819AbXJQUsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:48:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756542AbXJQUsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:48:50 -0400
Subject: Re: [GIT PULL] MMC updates
From: Dan Williams <dcbw@redhat.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20071017224422.78c082ec@poseidon.drzeus.cx>
References: <20071017224422.78c082ec@poseidon.drzeus.cx>
Content-Type: text/plain
Date: Wed, 17 Oct 2007 16:48:54 -0400
Message-Id: <1192654134.15090.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-17 at 22:44 +0200, Pierre Ossman wrote:
> Linus, please pull from
> 
>         git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-linus
> 
> The set includes one rare memory leak and some cleanup. It also includes a new frontend for the libertas driver. It is going via my tree because of interdependencies between my tree and the libertas/netdev tree.
> 
>  drivers/mmc/core/mmc.c                  |    3 +-
>  drivers/mmc/host/at91_mci.c             |    4 +-
>  drivers/net/wireless/Kconfig            |    6 +
>  drivers/net/wireless/libertas/Makefile  |    2 +
>  drivers/net/wireless/libertas/defs.h    |    2 +
>  drivers/net/wireless/libertas/if_sdio.c | 1072 +++++++++++++++++++++++++++++++
>  drivers/net/wireless/libertas/if_sdio.h |   45 ++

Libertas bits:

Acked-by: Dan Williams <dcbw@redhat.com>

>  include/linux/mmc/sdio_ids.h            |    6 +
>  8 files changed, 1136 insertions(+), 4 deletions(-)
> 
> Andrew Victor (1):
>       mmc: at91_mci: cleanup: use MCI_ERRORS
> 
> Florin Malita (1):
>       mmc: possible leak in mmc_read_ext_csd
> 
> Pierre Ossman (1):
>       net: libertas sdio driver
> 
> Rgds
> 

