Return-Path: <linux-kernel-owner+w=401wt.eu-S1756915AbXKNMGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbXKNMGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 07:06:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbXKNMGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 07:06:46 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38388 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751926AbXKNMGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 07:06:45 -0500
Date: Wed, 14 Nov 2007 12:05:42 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 2/2] sata_nv: fix ATAPI issues with memory over 4GB (v3)
Message-ID: <20071114120542.02b0b6da@the-village.bc.nu>
In-Reply-To: <473A7677.6080007@shaw.ca>
References: <473A7677.6080007@shaw.ca>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007 22:15:51 -0600
Robert Hancock <hancockr@shaw.ca> wrote:

> This fixes some problems with ATAPI devices on nForce4 controllers in ADMA mode
> on systems with memory located above 4GB. We need to delay setting the 64-bit
> DMA mask until the PRD table and padding buffer are allocated so that they don't
> get allocated above 4GB and break legacy mode (which is needed for ATAPI
> devices).
> 
> Signed-off-by: Robert Hancock <hancockr@shaw.ca>

Acked-by: Alan Cox <alan@redhat.com>
