Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbZHDCjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbZHDCjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 22:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbZHDCjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 22:39:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46255 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139AbZHDCjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 22:39:06 -0400
Date: Mon, 3 Aug 2009 22:39:04 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Helge Deller <deller@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: [GIT PULL] arch/parisc fixes for 2.6.31-rc6
Message-ID: <20090804023904.GG28572@bombadil.infradead.org>
References: <4A75C69E.4060307@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A75C69E.4060307@gmx.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 02, 2009 at 07:02:22PM +0200, Helge Deller wrote:
> Hi Linus,
>
> please pull the following changes for the HP parisc architecture.
>
> Thanks,
> Helge
>

Linus,

Please pull Helge's tree, I'm OK with it now (though I would have
definitely appreciated *some* notice.)

regards, Kyle

>
>
> The following changes since commit ed680c4ad478d0fee9740f7d029087f181346564:
>   Linus Torvalds (1):
>         Linux 2.6.31-rc5
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-2.6.git for-linus
>
> Helge Deller (5):
>       parisc: hp_sdc_mlc.c - check return value of down_trylock()
>       parisc: dino.c - check return value of pci_assign_resource()
>       parisc: sticore.c - check return values
>       parisc: parisc-agp.c - use correct page_mask function
>       parisc: hppb.c - fix printk format strings
>
> Jaswinder Singh Rajput (1):
>       parisc: includecheck fix for ccio-dma.c
>
> John David Anglin (2):
>       parisc: Fix GOT overflow during module load on 64bit kernel
>       parisc: Set correct bit in protection flags
>
> Michael Buesch (1):
>       parisc: isa-eeprom - Fix loff_t usage
>
> Roel Kluin (1):
>       parisc: Fix read buffer overflow in pdc_stable driver
>
> Stoyan Gaydarov (1):
>       parisc: fixed faulty check in lba_pci
>
>  arch/parisc/kernel/entry.S       |    2 +-
>  arch/parisc/kernel/module.c      |   50 ++++++++++++++++++++++++++++++++++----
>  drivers/char/agp/parisc-agp.c    |    2 +-
>  drivers/input/serio/hp_sdc_mlc.c |    2 +-
>  drivers/parisc/ccio-dma.c        |    1 -
>  drivers/parisc/dino.c            |    2 +-
>  drivers/parisc/eisa_eeprom.c     |    2 +-
>  drivers/parisc/hppb.c            |    9 ++++--
>  drivers/parisc/lba_pci.c         |    2 +-
>  drivers/parisc/pdc_stable.c      |    2 +-
>  drivers/video/console/sticore.c  |    9 +++++-
>  11 files changed, 65 insertions(+), 18 deletions(-)
>
>
