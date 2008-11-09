Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166AbYKILIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbYKILIT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 06:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbYKILII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 06:08:08 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40764 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752598AbYKILIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 06:08:07 -0500
Date: Sun, 9 Nov 2008 11:08:14 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: mathias.schnarrenberger@gmx.de
Cc: "Olaf van der Spek" <olafvdspek@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: security: delete BIOS password in keyboard buffer during kernel
 bootup
Message-ID: <20081109110814.13a4c099@lxorguk.ukuu.org.uk>
In-Reply-To: <200811090941.20401.mathias.schnarrenberger@gmx.de>
References: <200811081100.03966.mathias.schnarrenberger@gmx.de>
	<b2cc26e40811080839i387e5e94o519a5d1ff0086379@mail.gmail.com>
	<200811090941.20401.mathias.schnarrenberger@gmx.de>
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

On Sun, 9 Nov 2008 09:41:20 +0100
Mathias Schnarrenberger <mathias.schnarrenberger@gmx.de> wrote:

> > What if my BIOS stores some critical info at that memory address?
> > I don't think the kernel is the right place to work around this issue.
> 
> AFAIK every IBM PC compatible BIOS stores the keyboard buffer in this area.

Not every system we boot the x86 kernel on is a PC compatible.
