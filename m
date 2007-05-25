Return-Path: <linux-kernel-owner+w=401wt.eu-S1753129AbXEYAf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbXEYAf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 20:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750864AbXEYAfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 20:35:48 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35023 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750811AbXEYAfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 20:35:47 -0400
Date: Fri, 25 May 2007 01:38:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.22-rc1-mm1: IDE compile error
Message-ID: <20070525013817.26061764@the-village.bc.nu>
In-Reply-To: <46562B5A.2070008@zytor.com>
References: <20070515201914.16944e04.akpm@linux-foundation.org>
	<20070516185552.GA4086@stusta.de>
	<200705240145.38055.bzolnier@gmail.com>
	<20070524115549.01c0e1ca@the-village.bc.nu>
	<4656284D.7080709@zytor.com>
	<20070525011403.20e77ee7@the-village.bc.nu>
	<46562B5A.2070008@zytor.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The question I'm asking is: do you think it's better to remove this from
> hd.c, or do you think it's better to add it back boot code BIOS
> detection (and take the risk of poking an ST-506 disk with legacy data
> with parameters which may belong to another disk -- keep in mind this
> can permanently damage an ST-506 disk)?

To set it up the user will have to know the parameters and have typed
them into the BIOS (if it even has an option for it). I see no problem

