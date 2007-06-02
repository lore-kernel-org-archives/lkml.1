Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbXFDMr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbXFDMr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 08:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbXFDMru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 08:47:50 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38844 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751192AbXFDMrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 08:47:49 -0400
Date: Sat, 2 Jun 2007 23:22:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: 7eggert@gmx.de
Cc: Tejun Heo <htejun@gmail.com>, David Greaves <david@dgreaves.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       IDE Linux <linux-ide@vger.kernel.org>, ballen@gravity.phys.uwm.edu
Subject: Re: 2.6.22-rc3 hibernate(?) disables SMART on ide
Message-ID: <20070602232223.463932da@the-village.bc.nu>
In-Reply-To: <E1Hub8O-0000rF-Hb@be1.lrz>
References: <8rnax-6XX-11@gated-at.bofh.it>
	<8rA7H-1B4-1@gated-at.bofh.it>
	<E1Hub8O-0000rF-Hb@be1.lrz>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 3) There should be no bad effect from enabling smart, except if the BIOS
>    insists on not booting because of a bad RAID disk. (That's why I like
>    to disable it in the BIOS)

With a couple of exceptions unfortunately. Belongs in udev and smartd so
its controllable and flexible (and also swappable).

Alan
