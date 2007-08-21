Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbXHUWwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbXHUWwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 18:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753398AbXHUWwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 18:52:04 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36627 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752910AbXHUWwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 18:52:01 -0400
Date: Wed, 22 Aug 2007 00:00:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rene Herman <rene.herman@gmail.com>
Cc: =?UTF-8?B?Sm9zw6k=?= Luis =?UTF-8?B?UGF0acOxbyBBbmRyw6lz?= 
	<jopan@alumni.uv.es>,
       linux-kernel@vger.kernel.org
Subject: Re: Problems with IDE on linux 2.6.22.X
Message-ID: <20070822000003.6c561407@the-village.bc.nu>
In-Reply-To: <46CB626F.8020801@gmail.com>
References: <200708212149.12912.jopan@alumni.uv.es>
	<46CB626F.8020801@gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> "Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support"

Not for the newer chips. You want ATA/SATA (PIIX and possibly AHCI)
support from the new drivers, SCSI disk and SCSI cd.

> where you may need to boot with a "libata.atapi_enabled=0" kernel parameter.

Why deliberately disable atapi when you need atapi ?

Alan
