Return-Path: <linux-kernel-owner+w=401wt.eu-S1757852AbXIFAex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852AbXIFAex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 20:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756945AbXIFAem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 20:34:42 -0400
Received: from mobileweb01.london.02.net ([193.113.235.167]:55418 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756881AbXIFAek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 20:34:40 -0400
X-Greylist: delayed 521 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Sep 2007 20:34:35 EDT
Date: Thu, 6 Sep 2007 01:42:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Daniel J Blueman" <daniel.blueman@gmail.com>
Cc: "Tejun Heo" <htejun@gmail.com>, jgarzik@pobox.com,
       linux-ide@vger.kernel.org,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: ICH Intel PATA short cable override...
Message-ID: <20070906014209.142382c8@the-village.bc.nu>
In-Reply-To: <6278d2220709040537n4c96ffcagd9c25c94ddd29ca1@mail.gmail.com>
References: <6278d2220709040537n4c96ffcagd9c25c94ddd29ca1@mail.gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Sep 2007 13:37:22 +0100
"Daniel J Blueman" <daniel.blueman@gmail.com> wrote:

> We see that in ata_piix.c, there is a whitelist for (laptop) Intel ICH
> controllers with short cables, tied to specific vendor subsystem IDs.
> Since my mini-ITX Ibase MI910F has the subsystem IDs specified as
> Intel [1], this is unusable.
> 
> I can't find another existing mechanism to add short cable
> information, to allow UDMA/66 for my on-board CF socket.

DMI is the other approach (if your box has sane responses to the
dmidecode command we can do this). 
