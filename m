Return-Path: <linux-kernel-owner+w=401wt.eu-S1756190AbXIXVEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbXIXVEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 17:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbXIXVEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 17:04:23 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37253 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750858AbXIXVEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 17:04:22 -0400
Date: Mon, 24 Sep 2007 22:10:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Olaf Hering <olaf@aepfle.de>
Subject: Re: libata broken on Pegasos PPC platform (was: Re: IDE broken on
 Pegasos PPC platform)
Message-ID: <20070924221041.309b08e9@the-village.bc.nu>
In-Reply-To: <200709242258.28497.bzolnier@gmail.com>
References: <46F80BB1.7050902@redhat.com>
	<200709242258.28497.bzolnier@gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007 22:58:28 +0200
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> On Monday 24 September 2007, Chuck Ebbert wrote:
> > Without this patch, taken from a Suse 2.6.22 kernel, the Pegasos
> > PPC machines can't use their IDE interface. Is this the right fix?
> 
> This or use IDE via82cxxx driver.

Which contains a similar hack in the IDE driver where it doesn't belong 8)

> IIRC the patch comes from Olaf Hering (added to cc:) and is the way to go
> 
> Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Alan Cox <alan@redhat.com>

hopefully that means the hack in the old VIA driver can also be killed
off.
