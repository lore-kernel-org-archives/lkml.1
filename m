Return-Path: <linux-kernel-owner+w=401wt.eu-S1757376AbYLDKHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbYLDKHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 05:07:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbYLDKHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 05:07:20 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48939 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754239AbYLDKHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 05:07:18 -0500
Date: Thu, 4 Dec 2008 10:07:17 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Shane McDonald" <mcdonald.shane@gmail.com>
Cc: "Sergei Shtylyov" <sshtylyov@ru.mvista.com>, bzolnier@gmail.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Resurrect IT8172 IDE controller driver
Message-ID: <20081204100717.32819f1b@lxorguk.ukuu.org.uk>
In-Reply-To: <b2b2f2320812031839q43eb6102jbae0fbddd9a1cf75@mail.gmail.com>
References: <E1L4UpB-0007ro-1g@localhost>
	<492A8306.9000400@ru.mvista.com>
	<b2b2f2320812031839q43eb6102jbae0fbddd9a1cf75@mail.gmail.com>
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

> I am not sure how to determine if IORDY sampling is supported by a
> drive.  If I'm reading the code correctly, other drivers only check
> that the PIO mode is > 2 (not > 1 as in my driver) -- that seems to be
> the case for at least piix.c, siimage.c, and it8213.c.

Old IDE is wrong on this and in fact unless it has changed recently
simply can't cope with and doesn't provide functions for it. A libata
driver can use the libata helpers but those also rely on the core ata
code doing certain things so if you cut and paste it over you might have
to make other old IDE changes in parallel.

