Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320AbYLBKwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbYLBKwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 05:52:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbYLBKvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 05:51:52 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55858 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753013AbYLBKvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 05:51:51 -0500
Date: Tue, 2 Dec 2008 10:50:53 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "David Ellingsworth" <david@identd.dyndns.org>
Cc: "Mikael Pettersson" <mikpe@it.uu.se>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Promise PDC20376
Message-ID: <20081202105053.1bd78897@lxorguk.ukuu.org.uk>
In-Reply-To: <30353c3d0812011743we0bdddk2c9c37dd0191cf2a@mail.gmail.com>
References: <30353c3d0810240704n7476cc50y28b3eb8a5f326626@mail.gmail.com>
	<30353c3d0811250616o733fb7f9ob4af96dd604f78ea@mail.gmail.com>
	<18732.3809.720247.329641@harpo.it.uu.se>
	<30353c3d0812011743we0bdddk2c9c37dd0191cf2a@mail.gmail.com>
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

> A small update to this. It seems the above mentioned interrupt fails
> somewhere around the 128GB boundary. Interrupt 13h, AH=42 uses a 64
> bit sector address and should be capable of addressing the entire
> drive. For a SATA controller, this limitation seems relatively
> arbitrary. For IDE controllers, a limitation such as this is
> apparently common.

137GB I would imagine. That is the point at which LBA48 commands must be
used not LBA28 and presumably their BIOS code only supports old format
commands
