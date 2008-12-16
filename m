Return-Path: <linux-kernel-owner+w=401wt.eu-S1756739AbYLPOPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbYLPOPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 09:15:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754602AbYLPOPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 09:15:23 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46107 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754544AbYLPOPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 09:15:22 -0500
Date: Tue, 16 Dec 2008 14:15:33 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthieu CASTET <matthieu.castet@parrot.com>
Cc: linux-serial@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
       linux-kernel@vger.kernel.org
Subject: Re: s3c24xx : TIOCM_CTS handling problem
Message-ID: <20081216141533.7bcc5c9b@lxorguk.ukuu.org.uk>
In-Reply-To: <4947B065.5080405@parrot.com>
References: <48D242DC.30102@parrot.com>
	<4947B065.5080405@parrot.com>
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

> > And easy fix could be to always report TIOCM_CTS.
> > 
> Ping ?
> 
> The bug is still present on git tree and I have got no replies.

Send patches instead then ;)

If the chip can sense the CTS line then you could check on a timer event
but it might be cleaner to add the functionality needed to allow a driver
to say "always call my start_tx" method.

