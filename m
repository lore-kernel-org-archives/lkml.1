Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402AbYIVNQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbYIVNQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 09:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbYIVNQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 09:16:03 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42382 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753230AbYIVNQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 09:16:00 -0400
Date: Mon, 22 Sep 2008 14:15:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Niels de Vos <niels.devos@wincor-nixdorf.com>
Cc: linux-serial@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] serial: set correct baud_base for Oxford
 Semiconductor Ltd EXSYS EX-41092 Dual 16950 Serial adapter
Message-ID: <20080922141550.6e043f44@lxorguk.ukuu.org.uk>
In-Reply-To: <48D79977.30403@wincor-nixdorf.com>
References: <48D79977.30403@wincor-nixdorf.com>
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

On Mon, 22 Sep 2008 15:11:19 +0200
Niels de Vos <niels.devos@wincor-nixdorf.com> wrote:

> The PCI-card identified as "Oxford Semiconductor Ltd EXSYS EX-41092 Dual
> 16950 Serial adapter" is only usable with other devices (i.e. not the same
> card) after doing a "setserial /dev/ttyS<n> baud_base 115200".  This
> baud_base should be default for this card.
> 
> Signed-off-by: Niels de Vos <niels.devos@wincor-nixdorf.com>

Ok we'll give that one a go and hopefully it won't clash with anything
else this time. Queued for the ttydev tree


Alan
