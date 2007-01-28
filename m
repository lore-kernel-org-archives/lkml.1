Return-Path: <linux-kernel-owner+w=401wt.eu-S1752432AbXA1Mkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbXA1Mkg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 07:40:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbXA1Mkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 07:40:36 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43509 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751927AbXA1Mkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 07:40:35 -0500
Date: Sun, 28 Jan 2007 12:51:48 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: jgarzik@pobox.com, wkl@informatik.uni-kiel.de, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata: add a dummy set_mode() in pata_pcmcia
Message-ID: <20070128125148.2dfc1973@localhost.localdomain>
In-Reply-To: <200701281134.02218.arnd@arndb.de>
References: <200701281134.02218.arnd@arndb.de>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Jan 2007 11:34:01 +0100
Arnd Bergmann <arnd@arndb.de> wrote:

> CompactFlash cards in a passive PCMCIA adapter don't seem
> to like the ATA_CMD_SET_FEATURES command, which causes
> libata device probing to fail.
> 
> Since PCMCIA only allows PIO mode 0 anyway, there is no
> point in ever setting a higher speed. Adding the dummy
> function seems to do the right thing.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

NAK

See the update in bug #7711
