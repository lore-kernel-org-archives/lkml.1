Return-Path: <linux-kernel-owner+w=401wt.eu-S1763934AbYEFNRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763934AbYEFNRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 09:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756469AbYEFNRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 09:17:25 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45494 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753358AbYEFNRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 09:17:24 -0400
Date: Tue, 6 May 2008 14:08:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Martin =?UTF-8?B?TU9LUkVKxaA=?= <mmokrejs@ribosome.natur.cuni.cz>
Cc: Robert Hancock <hancockr@shaw.ca>, Jan Engelhardt <jengelh@medozas.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23.17 & 2.6.24.5 and maybe earlier: pata_marvell: need to
 disable DMA to get rid of '(ATA bus error)', 'ata7.00: status: { DRDY ERR
 }', 'ata7.00: error: { ICRC ABRT }'
Message-ID: <20080506140825.759db8f2@core>
In-Reply-To: <4820529D.2040609@ribosome.natur.cuni.cz>
References: <fa.+9Q+WQnyiYTlpbXVIzn6aT2/gS0@ifi.uio.no>
	<fa.fKUfeQYS9BFD60fOMormQ25ard4@ifi.uio.no>
	<fa.QYXSW2xjSxf6xnmd0rQGJhHLnrc@ifi.uio.no>
	<fa.qfeYSQtlsXzGvFvBQEdF9TFFpNg@ifi.uio.no>
	<481BD12D.1030406@shaw.ca>
	<4820529D.2040609@ribosome.natur.cuni.cz>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ata7.00: ATA-0: Delock 54111 512MB, Ver1.27, max UDMA/33
> ata7.00: 1006992 sectors, multi 0: LBA 

For some reason your CF card seems to think it is an ATA device not a CFA
device. What does the identify data for it look like (hdparm -I)


Alan
