Return-Path: <linux-kernel-owner+w=401wt.eu-S1756899AbYKWAKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899AbYKWAKf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 19:10:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbYKWAK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 19:10:26 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46579 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753607AbYKWAK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 19:10:26 -0500
Date: Sun, 23 Nov 2008 00:10:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] sysrq-j: emergency shell
Message-ID: <20081123001035.64234982@lxorguk.ukuu.org.uk>
In-Reply-To: <19f34abd0811221448p34770633keb5ea97f8e9bf62d@mail.gmail.com>
References: <20081121235159.GA15861@localhost.localdomain>
	<20081122172702.GB2748@x200.localdomain>
	<20081122190719.3ef24df6@lxorguk.ukuu.org.uk>
	<19f34abd0811221448p34770633keb5ea97f8e9bf62d@mail.gmail.com>
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

> But I realize that this does not necessarily mean that the other
> processes cannot read from or write to the tty anymore. Do you know
> how to do that? :-)

When you have control vhangup()


That just leaves the small matter of keymaps. I'm really not sure of the
point of this sysrq-j hack, it seems to me we have a perfectly good vt
switch mechanism
