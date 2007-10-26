Return-Path: <linux-kernel-owner+w=401wt.eu-S1759700AbXJZAcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759700AbXJZAcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 20:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbXJZAcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 20:32:42 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37040 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752432AbXJZAcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 20:32:41 -0400
Date: Fri, 26 Oct 2007 01:35:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ide: fix drive_is_ready() for non-PCI hosts and
 CONFIG_IDEPCI_SHARE_IRQ=y
Message-ID: <20071026013517.0063e24a@the-village.bc.nu>
In-Reply-To: <200710260230.52115.bzolnier@gmail.com>
References: <200710260136.37333.bzolnier@gmail.com>
	<20071026010515.260672b4@the-village.bc.nu>
	<200710260230.52115.bzolnier@gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007 02:30:52 +0200
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> On Friday 26 October 2007, Alan Cox wrote:
> > On Fri, 26 Oct 2007 01:36:37 +0200
> > Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> > 
> > > 
> > > Need to check if the host is a PCI one before reading IDE_ALTSTATUS_REG.
> > > 
> > > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > 
> > Umm why ? The altstatus register goes back to ST-506 and the original IBM
> > XT hard disk controller card ?
> 
> Thought that there have to be some (non-obvious) reason behing the fact that
> IDE_ALTSTATUS_REG reading was covered by #ifdef CONFIG_IDEPCI_SHARE_IRQ.

Only that reading altstatus is done to get the state without clearing the
IRQ which a status read would do.

Alan
