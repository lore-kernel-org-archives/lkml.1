Return-Path: <linux-kernel-owner+w=401wt.eu-S1753236AbXCMMh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbXCMMh1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 08:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbXCMMh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 08:37:27 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52004 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753226AbXCMMh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 08:37:26 -0400
Date: Tue, 13 Mar 2007 13:40:45 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: l.genoni@oltrelinux.com
Cc: htejun@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: IDE disk runs just in DMA/33 with 2.6.20.2 on nVidia CK804
 controller
Message-ID: <20070313134045.1ecc69c9@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0703131125270.24498@Phoenix.oltrelinux.com>
References: <Pine.LNX.4.64.0703131125270.24498@Phoenix.oltrelinux.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2007 13:13:12 +0100 (CET)
l.genoni@oltrelinux.com wrote:

> Hi,
> I reported this also for 2.6.20 kernel.
> new libata with controller nVidia CK804 initializes the disk in DMA/33,
> with with 2.6.19.5 and previous the disk is correctly inizialized in 
> DMA/100.
> Tha cable is OK, and with older kernels the disks runs without troubles.

I have the pieces that fix all this, but not yet integrated into the main
tree. With 2.6.21rc3 you have 80 wire cables you may find that simply
hacking the driver to set ATA_CBL_PATA80 is sufficient, but maybe not.

Alan
