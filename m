Return-Path: <linux-kernel-owner+w=401wt.eu-S1757782AbXLHMpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782AbXLHMpo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 07:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757389AbXLHMpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 07:45:33 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58581 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752652AbXLHMpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 07:45:32 -0500
Date: Sat, 8 Dec 2007 12:39:04 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jon Masters <jonathan@jonmasters.org>
Cc: Tejun Heo <htejun@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, notting@redhat.com,
       rusty@rustcorp.com.au, kay.sievers@vrfy.org, greg@kroah.com
Subject: Re: [PATCH] depmod: sort output according to modules.order
Message-ID: <20071208123904.5e0ae545@the-village.bc.nu>
In-Reply-To: <1197101392.20786.159.camel@perihelion>
References: <47555AF1.8090304@gmail.com>
	<47555C64.8070607@gmail.com>
	<20071205072529.GA5681@uranus.ravnborg.org>
	<47565452.3010800@gmail.com>
	<47565486.8050701@gmail.com>
	<20071205190609.GA14997@uranus.ravnborg.org>
	<47573403.1060203@gmail.com>
	<1197101392.20786.159.camel@perihelion>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> it doesn't output duplicate entries. Having duplicates is not the right
> solution - especially modalias entries that depend entirely upon the
> file layout on disk when you run depmod against a kernel.
> 
> Thanks for the ordering patches folks - a good idea!

And as it happens just what I need for the upcoming pata_legacy module
changes
