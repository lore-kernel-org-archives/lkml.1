Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815AbYHJMFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbYHJMFl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 08:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbYHJMFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 08:05:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49243 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218AbYHJMFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 08:05:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Grant Coady <gcoady.lk@gmail.com>
Subject: Re: Query: should 'Marvell SATA support' depend on PCI?
Date: Sun, 10 Aug 2008 14:08:10 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <vg3t941ebudmtb8afj82thuldug82ak1fs@4ax.com>
In-Reply-To: <vg3t941ebudmtb8afj82thuldug82ak1fs@4ax.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808101408.11393.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 10 of August 2008, Grant Coady wrote:
> Hi Alan,
> 
> I was reworking the ATA driver menu patch to shrink it (merge 'depends on' 
> lines) and noticed that the:
> 
> config SATA_MV
>         tristate "Marvell SATA support (HIGHLY EXPERIMENTAL)"
>         depends on EXPERIMENTAL
>         help
>           This option enables support for the Marvell Serial ATA family.
>           Currently supports 88SX[56]0[48][01] chips.
> 
> doesn't have 'depends on PCI && EXPERIMENTAL' like other drivers around 
> it, this is okay or should it also depend on PCI?

Well, I think so.  It obviously depends on PCI.

Thanks,
Rafael
