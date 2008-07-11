Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbYGKQj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbYGKQj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 12:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbYGKQjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 12:39:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:32797 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751789AbYGKQju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 12:39:50 -0400
Date: Fri, 11 Jul 2008 17:22:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: dhowells@redhat.com, alan@redhat.com, akpm@linux-foundation.org,
       linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MN10300: Fix MN10300's serial port driver to get at its
 tty_struct
Message-ID: <20080711172204.5552a0d9@lxorguk.ukuu.org.uk>
In-Reply-To: <25350.1215793078@redhat.com>
References: <20080711155113.256e89d1@lxorguk.ukuu.org.uk>
	<20080711145201.24870.13609.stgit@warthog.procyon.org.uk>
	<25350.1215793078@redhat.com>
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

On Fri, 11 Jul 2008 17:17:58 +0100
David Howells <dhowells@redhat.com> wrote:

> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > I don't suppose you'd consider putting the driver into drivers/serial so
> > it was actually sanely possible to update all the tty drivers together.
> > There are lots more changes to come and it would be easier if drivers
> > didn't keep hiding 8(
> 
> Do you want a bunch of .S files moving in there?

The .S files are a neccessary part of the tty driver ?
