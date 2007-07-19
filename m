Return-Path: <linux-kernel-owner+w=401wt.eu-S1759939AbXGSLIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939AbXGSLIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 07:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750889AbXGSLIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 07:08:06 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55977 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751169AbXGSLIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 07:08:04 -0400
Date: Thu, 19 Jul 2007 12:13:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andi Kleen <ak@suse.de>, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [58/58] x86: remove support for the Rise CPU
Message-ID: <20070719121340.08da9bbf@the-village.bc.nu>
In-Reply-To: <20070719104825.GR3801@stusta.de>
References: <200707191154.642492000@suse.de>
	<20070719095545.8AB5914E06@wotan.suse.de>
	<20070719114529.6fcd4022@the-village.bc.nu>
	<20070719104825.GR3801@stusta.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> - It's not only code, it also bloats everyone's kernel image.

Its a miniscule piece of code that is discarded on boot. Yes it might
make the image 100 bytes longer, but have you priced a 160GB disk
recently. I don't think 100 bytes of disk and 0 of memory really is worth
saving for any risk at all. Its not even worth the time to apply the
patch.

> - All it did was to fiddle with capabilities - if any computer with
>   a Rise cpu running Linux actually exists it should still work.
> - It's highly unlikely that we had any user of this code.

But you've no idea if this is true. Probably some of our other drivers
are bigger and have less users.

Alan
