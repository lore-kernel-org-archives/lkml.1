Return-Path: <linux-kernel-owner+w=401wt.eu-S1759400AbYGKPJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400AbYGKPJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 11:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbYGKPJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 11:09:35 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50321 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752671AbYGKPJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 11:09:35 -0400
Date: Fri, 11 Jul 2008 15:51:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: alan@redhat.com, akpm@linux-foundation.org, dhowells@redhat.com,
       linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MN10300: Fix MN10300's serial port driver to get at its
 tty_struct
Message-ID: <20080711155113.256e89d1@lxorguk.ukuu.org.uk>
In-Reply-To: <20080711145201.24870.13609.stgit@warthog.procyon.org.uk>
References: <20080711145201.24870.13609.stgit@warthog.procyon.org.uk>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2008 15:52:01 +0100
David Howells <dhowells@redhat.com> wrote:

> Fix MN10300's serial port driver to get at its tty_struct as this moved from
> struct uart_info into struct tty_port in patch:
> 
> 	commit 2500487cb5b4dbee56e127d699d14101016c5031
> 	Author: Alan Cox <alan@redhat.com>
> 	Date:   Fri Jul 11 17:23:39 2008 +1000
> 
> 	    07-serial-core-use-tty_port
> 
> 	    Switch the serial_core based drivers to use the new tty_port
> 	    structure. We can't quite use all of it yet because of the
> 	    dynamically allocated extras in the serial_core layer.
> 
> 	    Signed-off-by: Alan Cox <alan@redhat.com>
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

I don't suppose you'd consider putting the driver into drivers/serial so
it was actually sanely possible to update all the tty drivers together.
There are lots more changes to come and it would be easier if drivers
didn't keep hiding 8(

Alan
