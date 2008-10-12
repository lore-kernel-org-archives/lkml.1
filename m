Return-Path: <linux-kernel-owner+w=401wt.eu-S1756532AbYJLUXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532AbYJLUXm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 16:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbYJLUXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 16:23:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58793 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753216AbYJLUXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 16:23:34 -0400
Date: Sun, 12 Oct 2008 21:22:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adam =?UTF-8?B?VGxhxYJrYQ==?= <atlka@pg.gda.pl>
Cc: 7eggert@gmx.de, linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: [PATCH 0/2] SIGWINCH problem with terminal apps still alive
Message-ID: <20081012212244.117852e0@lxorguk.ukuu.org.uk>
In-Reply-To: <20081012210140.15cecf78@merlin.oi.pg.gda.pl>
References: <bjXel-4CU-17@gated-at.bofh.it>
	<bjYap-5Q0-25@gated-at.bofh.it>
	<bk30i-3Gx-1@gated-at.bofh.it>
	<bk6AV-8ms-7@gated-at.bofh.it>
	<bkrvO-1HF-49@gated-at.bofh.it>
	<blePJ-6rI-3@gated-at.bofh.it>
	<blmDC-7ZU-7@gated-at.bofh.it>
	<E1Kof4h-0005Q3-Ns@be1.7eggert.dyndns.org>
	<20081011185821.0dab4c81@lxorguk.ukuu.org.uk>
	<20081012143231.6ef9e590@merlin.oi.pg.gda.pl>
	<20081012152200.4a8f14c4@lxorguk.ukuu.org.uk>
	<20081012195957.50feada3@merlin.oi.pg.gda.pl>
	<20081012190312.0bd04ab8@lxorguk.ukuu.org.uk>
	<20081012210140.15cecf78@merlin.oi.pg.gda.pl>
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

> That is why I propose usage of real_tty in ioctl() handling:
> 
> case TIOCGWINSZ:
>                 return tiocgwinsz(real_tty, p);

Congratulations we've finally got there - and that is exactly the code in
the current tty tree.

Alan
