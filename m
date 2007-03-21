Return-Path: <linux-kernel-owner+w=401wt.eu-S1751594AbXCUBrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594AbXCUBrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 21:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbXCUBrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 21:47:25 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:50937 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbXCUBrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 21:47:24 -0400
Date: Tue, 20 Mar 2007 18:47:04 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, gregkh <greg@kroah.com>, tglx@linutronix.de
Subject: Re: 2.6.21-rc4-mm1
Message-Id: <20070320184704.8fd1bc64.randy.dunlap@oracle.com>
In-Reply-To: <20070319205623.299d0378.akpm@linux-foundation.org>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007 20:56:23 -0800 Andrew Morton wrote:

> 
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/
> 
> Will appear later at
> 
>   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc4/2.6.21-rc4-mm1/


UIO_CIF should depend on PCI ??

With CONFIG_PCI=n, I get:

ERROR: "pci_module_init" [drivers/uio/uio_cif.ko] undefined!
ERROR: "pci_release_regions" [drivers/uio/uio_cif.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
