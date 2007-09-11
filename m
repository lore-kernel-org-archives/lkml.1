Return-Path: <linux-kernel-owner+w=401wt.eu-S1763198AbXIKJna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763198AbXIKJna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 05:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756333AbXIKJnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 05:43:23 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60551 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754912AbXIKJnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 05:43:22 -0400
Date: Tue, 11 Sep 2007 10:51:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: mkrameshid <mkrameshid@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Calling PnP bios routines like get device node from x86_84 arch
Message-ID: <20070911105108.6d68a347@the-village.bc.nu>
In-Reply-To: <46E675E6.1040105@gmail.com>
References: <12594726.post@talk.nabble.com>
	<20070910173344.4bd2ae9e@the-village.bc.nu>
	<46E675E6.1040105@gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Actually I want to call the BIOS run time functions as per the 
> PNPBIOSSpecification-v1.0a (attached).

We use ACPI for x86_64, which means you need to use the ACPI methods not
the PnPBIOS ones. PnPBIOS isn't valid when ACPI is in use.

Alan
