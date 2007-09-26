Return-Path: <linux-kernel-owner+w=401wt.eu-S1757459AbXIZLKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459AbXIZLKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 07:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbXIZLKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 07:10:47 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56442 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750734AbXIZLKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 07:10:46 -0400
Date: Wed, 26 Sep 2007 12:16:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: AndrewL733 <AndrewL733@aol.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: NMI error and Intel S5000PSL Motherboards
Message-ID: <20070926121655.55334682@the-village.bc.nu>
In-Reply-To: <46FA3092.70108@aol.com>
References: <46FA3092.70108@aol.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Aug 29 09:02:10 master kernel: Uhhuh. NMI received for unknown reason 30.
> Aug 29 09:02:10 master kernel: Do you have a strange power saving mode 
> enabled?

What would be useful is to know under what situations that board can
raise NMI 30.

> In other words, Intel seems to be blaming the problem we are seeing on 
> something introduced starting with the 2.6.19 kernel. We are not looking 
> to blame anybody. We are only looking for a solution.

The first thing to find out is to find out in which kernel the behaviour
is introduced. It might also be worth disabling msi in case Intel screwed
the board up somewhat.

> Does anybody have an idea what could be going on here, as well as what 
> the solution may be? Going back to 2.6.18 or lower is not an option.

See if 2.6.20.* with the 2.6.18 driver compiles and how that behaves.
Also see if pci=nomsi and/or pci=nommconf make a difference.

Alan
