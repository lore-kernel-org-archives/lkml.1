Return-Path: <linux-kernel-owner+w=401wt.eu-S1758253AbYLDViM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253AbYLDViM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 16:38:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755458AbYLDVhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 16:37:55 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42919 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755196AbYLDVhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 16:37:54 -0500
Date: Thu, 4 Dec 2008 21:37:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Random host bus errors with pata_it821x, filesystem corruption
Message-ID: <20081204213749.78dd2eaf@lxorguk.ukuu.org.uk>
In-Reply-To: <200812042101.08613.linux@rainbow-software.org>
References: <200812042101.08613.linux@rainbow-software.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Dec  3 21:30:42 pentium kernel: ata3.00: status: { DRDY ERR }
> Dec  3 21:30:42 pentium kernel: ata3.00: error: { IDNF }

The drive firmware is reporting an unreadable block (or invalid block
number)

> I wonder what might cause these errors? I switched the controller into non-RAID mode and read SMART - both drives
> are 100% OK (no pending or reallocated sectors, no errors logged).

I would keep the controller in that mode anyway to be honest - the RAID
mode firmware is a bit variable and some versions blow up for reasons
I've never figured.

Alan
