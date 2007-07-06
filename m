Return-Path: <linux-kernel-owner+w=401wt.eu-S1764156AbXGFRhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764156AbXGFRhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 13:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762584AbXGFRhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 13:37:42 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43171 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761321AbXGFRhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 13:37:41 -0400
Date: Fri, 6 Jul 2007 18:44:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] pata_ali not working on a 64 bit system
Message-ID: <20070706184402.16d290b7@the-village.bc.nu>
In-Reply-To: <20070706173605.GA6484@dreamland.darkstar.lan>
References: <20070706173605.GA6484@dreamland.darkstar.lan>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2007 19:36:05 +0200
Luca Tettamanti <kronos.it@gmail.com> wrote:

> Hello,
> I found out that pata_ali is not working with a 64 bit kernel, while a
> 32 bit kernel on the same machine works fine. I'm running a very recent
> kernel (872aad45, somewhere after 2.6.22-rc7).
> 
> The problem is that as soon as the module is loaded I get a screaming
> interrupt:

Can you report this with a full dmesg to the ACPI maintainers as that is
where the IRQ routing is presumably coming from. Are you using ACPI on
both cases ?
