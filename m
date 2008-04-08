Return-Path: <linux-kernel-owner+w=401wt.eu-S1755886AbYDHWRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbYDHWRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 18:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbYDHWRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 18:17:40 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37562 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752634AbYDHWRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 18:17:39 -0400
Date: Tue, 8 Apr 2008 23:13:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org,
       Paul Hardwick <p.hardwick@option.com>
Subject: Re: [PATCH] tty/serial: Lay the foundations for the next set of
 reworks
Message-ID: <20080408231348.190abf20@core>
In-Reply-To: <47FBEA09.6090507@gmail.com>
References: <20080408165839.47df4517@core>
	<47FBEA09.6090507@gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, how exactly the card behaves on 1 byte write? And how did the .write 
> protect against it?

One byte writes work fine via the write path and already occur. I suspect
the original author forgot to turn echo off and saw fun things happening
between the inbuilt modem emulation and the Linux side.
