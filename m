Return-Path: <linux-kernel-owner+w=401wt.eu-S1757672AbYJETMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672AbYJETMA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 15:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757434AbYJETLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 15:11:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40050 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757130AbYJETL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 15:11:29 -0400
Date: Sun, 5 Oct 2008 20:10:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Pekka Enberg" <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] kmemcheck: fix crash in PnP BIOS calls
Message-ID: <20081005201056.5b9b2f53@lxorguk.ukuu.org.uk>
In-Reply-To: <19f34abd0810051204u241659b4j6a9ef2ab3616d3fc@mail.gmail.com>
References: <20081005172504.GB24825@localhost.localdomain>
	<20081005191555.5715da29@lxorguk.ukuu.org.uk>
	<19f34abd0810051204u241659b4j6a9ef2ab3616d3fc@mail.gmail.com>
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

> catch those reads/writes just fine. I'm not sure if the BIOS code can
> change segments (it would need to switch LDT/GDTs, I think), and even

It can do so if it wants as far as I can tell

> if it did, I find it unlikely that it would directly access kernel
> memory using these new segment registers. Do you happen to know of any
> such cases?

No. The code either seems to be very simple or just be an SMM trap in the
BIOSes I've seen
