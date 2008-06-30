Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbYF3Oov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbYF3Oov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 10:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbYF3Ool
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 10:44:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55626 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751257AbYF3Ook (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 10:44:40 -0400
Date: Mon, 30 Jun 2008 15:26:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Stefan Becker <Stefan.Becker@nokia.com>,
       ext David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, ext Alan Stern <stern@rowland.harvard.edu>
Subject: Re: PATCH: 2.6.26-rc8: Fix IRQF_DISABLED for shared interrupts
Message-ID: <20080630152637.5dfc68f2@lxorguk.ukuu.org.uk>
In-Reply-To: <20080630142822.GA22984@khazad-dum.debian.net>
References: <Pine.LNX.4.44L0.0806281241200.23326-100000@netrider.rowland.org>
	<200806281251.21299.david-b@pacbell.net>
	<4867A2DE.3070509@nokia.com>
	<200806292009.26975.david-b@pacbell.net>
	<48686D8F.8010901@nokia.com>
	<20080630142822.GA22984@khazad-dum.debian.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> IMO, the safe thing to do is to block shared IRQs from being used as random
> sources.

All IRQs on most modern boxes go over the same bus, shared or otherwise.
If anything that should add to the noise.

Alan
