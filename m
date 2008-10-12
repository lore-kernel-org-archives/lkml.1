Return-Path: <linux-kernel-owner+w=401wt.eu-S1757133AbYJLSNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133AbYJLSNE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 14:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754577AbYJLSMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 14:12:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34513 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754520AbYJLSMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 14:12:53 -0400
Date: Sun, 12 Oct 2008 19:12:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: gettinther <gettinther@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: Marvell 88SE6141
Message-ID: <20081012191251.1705b0ae@lxorguk.ukuu.org.uk>
In-Reply-To: <64630f150810111641s764e454n43baf759b7848373@mail.gmail.com>
References: <64630f150810111641s764e454n43baf759b7848373@mail.gmail.com>
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

> Just letting you know in case you just forgot to include it.  Or is
> there is another issue I should be aware of.

For current kernels it is driven by pata_marvell or should be.

Until 2.6.27 AHCI and pata_marvell would fall out, which was a problem as
only pata_marvell supports the PATA interfaces too. As of 2.6.27 you get
pata_marvell if you have PATA support for Marvell stuff enabled, AHCI
otherwise so this can probably now be merged.
