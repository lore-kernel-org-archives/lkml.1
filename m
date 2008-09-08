Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbYIHUE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbYIHUE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 16:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbYIHUEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 16:04:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58175 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753417AbYIHUEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 16:04:20 -0400
Date: Mon, 8 Sep 2008 21:03:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: "Greg KH" <gregkh@suse.de>, "Linux kernel" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <torvalds@linux-foundation.org>, <stable@kernel.org>
Subject: Re: Linux 2.6.25.17
Message-ID: <20080908210352.2b0cd70e@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.61.0809081535280.5096@chaos.analogic.com>
References: <20080908143516.GA7311@suse.de>
	<Pine.LNX.4.61.0809081535280.5096@chaos.analogic.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If I remove one of the CPUs, there is no file-system corruption
> so I fear that there is some lock missing somewhere in the
> serial ATA driver code (ata_piix or sata_sil).

All the logic and locking is in the core code so would show up on all
sorts of boxes. You say you are using sata_sil - is this on an Nvidia
board ?

> If anybody has anything to test with my setup, I can readily
> test both with and without the two CPUs.

Can you duplicate this with the drives just on the ata_piix ?

Alan
