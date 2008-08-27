Return-Path: <linux-kernel-owner+w=401wt.eu-S1757171AbYH0Q4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171AbYH0Q4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 12:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbYH0Q4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 12:56:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35585 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752724AbYH0Q4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 12:56:39 -0400
Date: Wed, 27 Aug 2008 17:37:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Denis Joseph Barrow <D.Barow@option.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, greg@kroah.com,
       Linux USB kernel mailing list <linux-usb@vger.kernel.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: question wrt /drivers/char/tty_io.c in pre 2.6.16 code
Message-ID: <20080827173746.11b91c07@lxorguk.ukuu.org.uk>
In-Reply-To: <48B578F3.1050908@option.com>
References: <20080820010353.593820280@mini.kroah.org>
	<20080820010752.GB3365@kroah.com>
	<48B52064.9070700@pobox.com>
	<48B578F3.1050908@option.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The new tty_insert_flip_string returns the
> number of bytes successfully copied to tty recieve buffers
> how do I implement this functionality in pre 2.6.16 code,
> can it be done?

Probably but it'll be really ugly. You need to stick your nose into the
innards of struct tty_struct and check the space left in the current flip
buffer entry.

What you do if it is full is another question.

Alan.
