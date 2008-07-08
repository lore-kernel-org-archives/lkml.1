Return-Path: <linux-kernel-owner+w=401wt.eu-S1757910AbYGHU2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbYGHU2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 16:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755799AbYGHU2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 16:28:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51718 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755940AbYGHU2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 16:28:16 -0400
Date: Tue, 8 Jul 2008 20:55:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ds1620: Push BKL down
Message-ID: <20080708205536.2020e2a1@the-village.bc.nu>
In-Reply-To: <20080708200841.GB31327@flint.arm.linux.org.uk>
References: <20080522213529.1423c01f@core>
	<20080708200841.GB31327@flint.arm.linux.org.uk>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2008 21:08:42 +0100
Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> On Thu, May 22, 2008 at 09:35:29PM +0100, Alan Cox wrote:
> > Push down the BKL and correct the ioctl return for unknown ioctls.
> 
> In principle, no issues with the patch, and I'd ack it.  However, I've
> made some comments about whether the BKL is needed in all these places.
> Whether your intention is just to push the BKL down or to actually
> eliminate it will of course determine whether you want to delete those.

My intention is to keep pushing until it becomes another maintainers
problem to push further. I'll revamp this diff when I have a bit of time
to get back around to it and I'll push down/remove the lock further in
accordance with your comments.

Alan
