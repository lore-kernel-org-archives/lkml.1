Return-Path: <linux-kernel-owner+w=401wt.eu-S932662AbYJKR7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662AbYJKR7m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 13:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932585AbYJKR7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 13:59:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57528 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932570AbYJKR7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 13:59:14 -0400
Date: Sat, 11 Oct 2008 18:58:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: 7eggert@gmx.de
Cc: Adam Tla?ka <atlka@pg.gda.pl>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org
Subject: Re: [PATCH 0/1] SIGWINCH problem with terminal apps still alive
Message-ID: <20081011185821.0dab4c81@lxorguk.ukuu.org.uk>
In-Reply-To: <E1Kof4h-0005Q3-Ns@be1.7eggert.dyndns.org>
References: <bjXel-4CU-17@gated-at.bofh.it>
	<bjYap-5Q0-25@gated-at.bofh.it>
	<bk30i-3Gx-1@gated-at.bofh.it>
	<bk6AV-8ms-7@gated-at.bofh.it>
	<bkrvO-1HF-49@gated-at.bofh.it>
	<blePJ-6rI-3@gated-at.bofh.it>
	<blmDC-7ZU-7@gated-at.bofh.it>
	<E1Kof4h-0005Q3-Ns@be1.7eggert.dyndns.org>
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

> Alan, do you agree? Or is it required to take both locks at the same time?
> If it is, in which order?

I don't agree. Please read the code more carefully. In paticular note
that TIOCGWINSZ is driven off the tty side of any tty/pty pair. That we
set the pty size termios bits is really a curiousity of history.

Alan
