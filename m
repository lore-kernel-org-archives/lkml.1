Return-Path: <linux-kernel-owner+w=401wt.eu-S1755696AbYACWci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696AbYACWci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 17:32:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbYACWca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 17:32:30 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56030 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753092AbYACWca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 17:32:30 -0500
Date: Thu, 3 Jan 2008 22:30:54 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthias Goebl <matthias@goebl.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kkeil@suse.de,
       kai.germaschewski@gmx.de
Subject: Re: [PATCH] isdn/i4l: 'NO CARRIER' message lost after ldisc flush
Message-ID: <20080103223054.2b51450b@lxorguk.ukuu.org.uk>
In-Reply-To: <20080103220039.GV19071@night.goebl.net>
References: <1178571957.3665.8.camel@amdx2.microgate.com>
	<20080103220039.GV19071@night.goebl.net>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For non-audio connections the problem remains.
> Maybe we can remove the tty_ldisc_flush() in isdn_tty_modem_result()
> at all because it's done at tty_close?

I'm not sure I understand why the tty_ldisc_flush is being done in the
ISDN layer at this point but this change looks fine to me.


Alan
