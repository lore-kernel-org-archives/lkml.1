Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262AbYAARoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbYAARoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 12:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbYAARoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 12:44:09 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56580 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754607AbYAARoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 12:44:08 -0500
Date: Tue, 1 Jan 2008 17:35:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove CONFIG_EXPERIMENTAL
Message-ID: <20080101173532.1db4019f@the-village.bc.nu>
In-Reply-To: <20080101163337.GX2360@does.not.exist>
References: <20080101134809.GK2360@does.not.exist>
	<20080101142344.769f16c7@the-village.bc.nu>
	<20080101151751.GW2360@does.not.exist>
	<20080101160708.5bb5cc2a@the-village.bc.nu>
	<20080101163337.GX2360@does.not.exist>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So smbfs is still considered rock solid while no serious distribution 
> would be crazy enough to ship the EXPERIMENTAL NFSv4 support to their 
> customers?

Thats a different problem. The kernel as I've said many times has no
proper process for

- removing expired/missing maintainers
- handling stuff that decays
- removing dead documentation
- removing dead drivers and ports

Although you've certainly started on fixing much of that.

> I'm not claiming that all EXPERIMENTAL tags were wrong [1], but many 
> were wrong.

So why not fix the wrong tags, and mark smbfs obsolete ?

> Plus the fact that CONFIG_EXPERIMENTAL controlled so many different 
> things with one switch that CONFIG_EXPERIMENTAL=n .config's are really 
> rare.

Agreed
