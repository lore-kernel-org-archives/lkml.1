Return-Path: <linux-kernel-owner+w=401wt.eu-S1762849AbXJMTwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762849AbXJMTwT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 15:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbXJMTwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 15:52:07 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43543 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752737AbXJMTwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 15:52:05 -0400
Date: Sat, 13 Oct 2007 20:56:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git patches] IDE updates (part 2)
Message-ID: <20071013205618.3ddc91e9@the-village.bc.nu>
In-Reply-To: <200710131825.24768.bzolnier@gmail.com>
References: <200710131825.24768.bzolnier@gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Oct 2007 18:25:24 +0200
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> 
> Hi,
> 
> highlights of this update:
> 
> * Rework of IDE PMAC host driver: bugfixes, removal of the code
>   duplicated from the IDE core and conversion to use the generic
>   DMA tuning code path (the rework cuts ide-pmac.c by ~200 LOC).

Reading the current driver from the git tree I don't see how the PCI
driver ever sets the ctl register base. It seems to always be set to zero
which means you can't issue SRST and reset sequences ?

