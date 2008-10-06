Return-Path: <linux-kernel-owner+w=401wt.eu-S1753622AbYJFKwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbYJFKwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 06:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbYJFKwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 06:52:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49278 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752004AbYJFKwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 06:52:23 -0400
Date: Mon, 6 Oct 2008 11:50:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Alan Cox <alan@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 67/76] tty: Remove lots of NULL checks
Message-ID: <20081006115040.1e733173@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0810061055550.5594@anakin>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
	<20081005162321.1997.71337.stgit@localhost.localdomain>
	<Pine.LNX.4.64.0810061055550.5594@anakin>
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

> I have no idea what this `bcc' thingy does, but its removal just struck
> my eye...

Thanks - keeps a checksum byte per packet up to date if checksumming is
in use so having the right value is a good idea.

Fixed
