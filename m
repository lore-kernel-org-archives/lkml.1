Return-Path: <linux-kernel-owner+w=401wt.eu-S1756728AbYKVTHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbYKVTHY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 14:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbYKVTHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 14:07:11 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50247 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751030AbYKVTHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 14:07:10 -0500
Date: Sat, 22 Nov 2008 19:07:19 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] sysrq-j: emergency shell
Message-ID: <20081122190719.3ef24df6@lxorguk.ukuu.org.uk>
In-Reply-To: <20081122172702.GB2748@x200.localdomain>
References: <20081121235159.GA15861@localhost.localdomain>
	<20081122172702.GB2748@x200.localdomain>
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

> > It seems that keyboard input will go to the shell only half of the
> > time; the other half goes to whatever program was running there in
> > the first place. I tried to kill the other users of the TTY using
> > TIOCSCTTY, but it seems not to have worked. Any ideas?
> 
> This should go in together with CVE number attached.

TIOCSTTY isn't supposed to kill anything.

Alan
