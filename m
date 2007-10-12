Return-Path: <linux-kernel-owner+w=401wt.eu-S1757457AbXJLO0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbXJLO0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 10:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbXJLO0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 10:26:14 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:47638 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbXJLO0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 10:26:14 -0400
Date: Fri, 12 Oct 2007 15:25:58 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git patches] IDE updates (part 1)
In-Reply-To: <200710120034.49730.bzolnier@gmail.com>
Message-ID: <Pine.LNX.4.64N.0710121518030.21684@blysk.ds.pg.gda.pl>
References: <200710120034.49730.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2007, Bartlomiej Zolnierkiewicz wrote:

> * Kconfig facelift - as a result of this change users have three less
>   config options to worry about (BLK_DEV_IDEPCI, BLK_DEV_IDEDMA_PCI
>   and IDE_CHIPSETS) and can just select host drivers that they need

 Well, it depends on how you look at it.  If you have PCI, an on-board IDE 
interface and do not want any PCI IDE controllers, then you now have a 
zillion of options to disable instead of just one.  Have a look at 
"arch/mips/configs/sb1250-swarm_defconfig" for an example (hmm..., 
CONFIG_BLK_DEV_IDE_SWARM disabled by default -- that should probably be 
changed; I'll cook a patch).  I guess it is not possible to make everyone 
happy at once though, so please do not treat it as a hard objection. :-)

  Maciej
