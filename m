Return-Path: <linux-kernel-owner+w=401wt.eu-S1761446AbYHEMrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761446AbYHEMrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 08:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759175AbYHEMrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 08:47:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51437 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756854AbYHEMrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 08:47:14 -0400
Date: Tue, 5 Aug 2008 13:29:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linasvepstas@gmail.com
Cc: "Robert Hancock" <hancockr@shaw.ca>, "John Stoffel" <john@stoffel.org>,
       "Alistair John Strachan" <alistair@devzero.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: amd64 sata_nv (massive) memory corruption
Message-ID: <20080805132957.398c1036@lxorguk.ukuu.org.uk>
In-Reply-To: <3ae3aa420808042229l675ffd79p42a5691532b7ac3b@mail.gmail.com>
References: <fa.qB5d+HsAJ6G05jNoeU8Q9GV6Dow@ifi.uio.no>
	<fa.fxlDAHxOnGgcBiOH/EOauE67ZPc@ifi.uio.no>
	<fa.1WYUmN6FHR5yW+sXoYRFN22Y8S8@ifi.uio.no>
	<fa.LAUkvEUlYiF69V/F8F3wigxqH9w@ifi.uio.no>
	<fa.mXeFXYNkfZfUYPQcGwzok0IOIfY@ifi.uio.no>
	<fa.KjbvCGbUr2JeQTcwA1/sFGIIMik@ifi.uio.no>
	<489675DC.2080906@shaw.ca>
	<3ae3aa420808042229l675ffd79p42a5691532b7ac3b@mail.gmail.com>
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

> have EDAC turned on, or something ... I'm investigating now.
> But this is moot -- if there is software that already exists that
> could have reported the error to the kernel, then this software
> should have been installed/enabled/operating by default.

That gets you into arguments with the people who care about performance
but its really a distribution level debate and I suspect the answer is
itself distro specific depending on usage/

> Personally I'm ready to pop $$$ for ECC it if will actually do
> something for me, this has been painful.

On a decent system ECC will do something. A modern server PC actually has
pretty good coverage on CPU L1, L2 and optionally RAM. I/O controllers
and disk internal caches seem to be a bit more variable which is one
reason big HPC cluster projects often checksum end to end - when you
produce terabytes of data all the one in a hundred billion error stats
start to look less than reassuring.

Alan
