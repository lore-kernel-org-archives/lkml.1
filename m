Return-Path: <linux-kernel-owner+w=401wt.eu-S932646AbXHCNGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646AbXHCNGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 09:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762138AbXHCNG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 09:06:28 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49916 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760424AbXHCNG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 09:06:27 -0400
Date: Fri, 3 Aug 2007 14:13:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Complete freeze if high traffic on standard serial line on
 ia32?
Message-ID: <20070803141347.19136546@the-village.bc.nu>
In-Reply-To: <465648.43203.qm@web26903.mail.ukl.yahoo.com>
References: <465648.43203.qm@web26903.mail.ukl.yahoo.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  I can reliably (6 times in one hour) freeze completely (Scroll lock/Caps lock
> flashing together, mouse frozen in X) my PC (AMD sempron on MSI K8MM3-V K8M800
> Socket 754) by doing an FTP using a standard modem connected on the serial port
> of the motherboard, and a bit of browsing (i.e. machine not loaded).
>  That happens on standard Fedora 7 kernel and on the latest 23-rc1 kernel, and
> doesn't happen on a Puppy Linux 2.17 bootable CDROM.

Can you get this to happen outside of X at all (eg if you do a yum update
and pull in packages over the modem for a while with 2.6.23-rc1  does it
die). Just trying to work out what has become unstable.

Also worth trying to see if browsing web type stuff off a CD or local
files triggers it without the network link.
