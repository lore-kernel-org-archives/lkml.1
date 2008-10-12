Return-Path: <linux-kernel-owner+w=401wt.eu-S1759313AbYJLOXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313AbYJLOXQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 10:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbYJLOXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 10:23:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46842 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751181AbYJLOW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 10:22:59 -0400
Date: Sun, 12 Oct 2008 15:22:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adam =?UTF-8?B?VGxhxYJrYQ==?= <atlka@pg.gda.pl>
Cc: 7eggert@gmx.de, linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: [PATCH 0/2] SIGWINCH problem with terminal apps still alive
Message-ID: <20081012152200.4a8f14c4@lxorguk.ukuu.org.uk>
In-Reply-To: <20081012143231.6ef9e590@merlin.oi.pg.gda.pl>
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

O> real_tty structures. TIOCSWINSZ and TIOCGWINSZ ioctls could be
> called on tty and real_tty at the same time. To avoid race condition

No they can't. Would you please bother to spend five minutes actually
reading the source code and following through your assumptions to see if
they make sense before posting.

tiocgwinsz is never called for the pty side of a pty pair.


