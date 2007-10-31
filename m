Return-Path: <linux-kernel-owner+w=401wt.eu-S1757744AbXJaMtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744AbXJaMtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 08:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755732AbXJaMsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 08:48:53 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40530 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755635AbXJaMsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 08:48:52 -0400
Date: Wed, 31 Oct 2007 12:49:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Daniel Drake <dsd@gentoo.org>, linux list <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: "Fix ATAPI transfer lengths" causes CD writing regression
Message-ID: <20071031124908.19de7833@the-village.bc.nu>
In-Reply-To: <20071031115754.GK5059@kernel.dk>
References: <47274A5F.6070409@gentoo.org>
	<20071030153417.59b9182c@the-village.bc.nu>
	<47276DCA.1000808@gentoo.org>
	<20071030190153.373c9347@the-village.bc.nu>
	<47278439.4030801@gentoo.org>
	<20071031114958.210bd7cc@the-village.bc.nu>
	<20071031115754.GK5059@kernel.dk>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Would need to double check the SCSI specificatons to be sure but I think
> > you are asking for less data than the drive wishes to provide. You
> > aren't allowed to do that with ATA.
> 
> ide-cd handles this by throwing the excess away, which I think is the
> sane way to do this.

It also fails for some cases because the controller snoops the length
information in the packet command.

Alan
