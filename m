Return-Path: <linux-kernel-owner+w=401wt.eu-S1758013AbYJMIkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013AbYJMIkM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 04:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756250AbYJMIjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 04:39:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50842 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755134AbYJMIjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 04:39:54 -0400
Date: Mon, 13 Oct 2008 09:39:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Alexander V. Lukyanov" <lav@netis.ru>
Cc: Jan Engelhardt <jengelh@medozas.de>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Ncurses Developers <ncurses-dev@gnu.org>
Subject: Re: linux 2.6.26 vt back_color_erase
Message-ID: <20081013093924.648c892d@lxorguk.ukuu.org.uk>
In-Reply-To: <20081013052437.GA27761@night.netis.ru>
References: <20081003081147.GA16414@night.netis.ru>
	<20081010164953.GA27092@night.netis.ru>
	<alpine.LNX.1.10.0810101310400.21097@fbirervta.pbzchgretzou.qr>
	<20081013052437.GA27761@night.netis.ru>
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

> Probably color ls -l is just broken and should be fixed. Why was it
> necessary to change the console color semantics that was there for years?

Submit a patch that reverts the change. I would agree it needs reverting.

> 
> > ncurses should not expect anything. Except what is in terminfo.
> > Do we need a terminfo db update for the "linux" term?
> 
> Sure, unless the change is reverted. The bce attribute will need to be
> disabled, which is a pity as it saves traffic for color full screen
> applications. And changing terminfo is very inconvenient for remote logins.

Agreed
