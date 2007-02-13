Return-Path: <linux-kernel-owner+w=401wt.eu-S1751278AbXBMLET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278AbXBMLET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 06:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbXBMLET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 06:04:19 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36068 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751278AbXBMLES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 06:04:18 -0500
Date: Tue, 13 Feb 2007 11:18:03 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] fix error management in 8250_pci.c pciserial_resume_one
Message-ID: <20070213111803.34292562@localhost.localdomain>
In-Reply-To: <20070213113010.27125d53@localhost>
References: <20070213113010.27125d53@localhost>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Feb 2007 11:30:10 +0100
Stefano Brivio <stefano.brivio@polimi.it> wrote:

>   CC      drivers/serial/8250_pci.o
> drivers/serial/8250_pci.c: In function 'pciserial_resume_one':
> drivers/serial/8250_pci.c:1830: warning: ignoring return value of 'pci_enable_device', declared with attribute warn_unused_result
> 
> This patch fixes it.

NAK. as ith the past several times people proposed this. The bug is in
the pci_enable_device header being must_check
