Return-Path: <linux-kernel-owner+w=401wt.eu-S932099AbXIUVDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbXIUVDf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 17:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762670AbXIUU4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:56:51 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49295 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765271AbXIUU4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:56:49 -0400
Date: Fri, 21 Sep 2007 22:03:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Valdis.Kletnieks@vt.edu, David Miller <davem@davemloft.net>,
       jeff@garzik.org, mchan@broadcom.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] bnx2: factor out gzip unpacker
Message-ID: <20070921220333.3b31afb5@the-village.bc.nu>
In-Reply-To: <200709212018.06553.vda.linux@googlemail.com>
References: <200709211201.24475.vda.linux@googlemail.com>
	<200709211905.23946.vda.linux@googlemail.com>
	<15775.1190399812@turing-police.cc.vt.edu>
	<200709212018.06553.vda.linux@googlemail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> For example, bnx2 maintainer says that driver and
> firmware are closely tied for his driver. IOW: you upgrade kernel
> and your NIC is not working anymore.
> 
> Another argument is to make kernel be able to bring up NICs
> without needing firmware images in initramfs/initrd/hard drive.

dgrs should be using the request_firmware interface. Actually dgrs is
probably a good candidate for /dev/null

Alan
