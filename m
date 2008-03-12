Return-Path: <linux-kernel-owner+w=401wt.eu-S1753549AbYCLNnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbYCLNnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 09:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbYCLNnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 09:43:14 -0400
Received: from zux006-051-205.adsl.green.ch ([81.6.51.205]:11325 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751130AbYCLNnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 09:43:13 -0400
Date: Wed, 12 Mar 2008 13:22:10 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty_ioctl: Soft carrier handling
Message-ID: <20080312132210.42327363@the-village.bc.nu>
In-Reply-To: <47D5B504.6020909@gmail.com>
References: <20080310215613.43c7acb0@core>
	<47D5B504.6020909@gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > +	int bit = arg ? CLOCAL : 0;
> > +	struct ktermios old = *tty->termios;
> 
> Maybe a dumb question, but shouldn't be the snapshot done in the critical 
> section too?

Yes it should. I'll fix that in the next bits and double check the cases
Andrew asks about (although I think they are ok with caller locking from
memory)

Alan
