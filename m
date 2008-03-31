Return-Path: <linux-kernel-owner+w=401wt.eu-S1758234AbYCaVop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234AbYCaVop (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 17:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756869AbYCaVof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 17:44:35 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48610 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756632AbYCaVoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 17:44:34 -0400
Date: Mon, 31 Mar 2008 22:43:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Michael Schmitz <schmitz@debian.org>
Subject: Re: [PATCH 5/5] falconide/q40ide: add ->atapi_*put_bytes and
 ->ata_*put_data methods
Message-ID: <20080331224318.4768c050@core>
In-Reply-To: <200803312341.08271.zippel@linux-m68k.org>
References: <200803312341.08271.zippel@linux-m68k.org>
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

> That would require an additional data copy and a double byteswap on machines 
> which are not that fast in first place...

So use the blitter ;)

At this point the future is not Commode Amiga or Atari TT and we risk
mess in core code for obscure platforms ?

Alan
