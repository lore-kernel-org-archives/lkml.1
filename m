Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbXHXKhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbXHXKhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 06:37:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754486AbXHXKg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 06:36:57 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:32799 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754385AbXHXKg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 06:36:56 -0400
Date: Fri, 24 Aug 2007 11:45:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eric Lammerts <eric@lammerts.org>
Cc: linux-kernel@vger.kernel.org, p.hardwick@option.com, greg@kroah.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] nozomi DTR/RTS
Message-ID: <20070824114503.531a74f9@the-village.bc.nu>
In-Reply-To: <46CEACC0.5000908@lammerts.org>
References: <46CEACC0.5000908@lammerts.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Attached patch adds a tty_ops->tiocmset function that makes it work.
> 
> Should we also rip out the TIOCMBIS/TIOCMBIC handling in ntty_ioctl()? 
> It doesn't seem to be used anyway.

Yes - its bogus.
