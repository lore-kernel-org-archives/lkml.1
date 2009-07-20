Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495AbZGTXrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbZGTXrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 19:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485AbZGTXrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 19:47:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46206 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754484AbZGTXrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 19:47:04 -0400
Date: Tue, 21 Jul 2009 00:48:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dwayne Rightler <drightler@technicalogic.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: No UDMA with BLK_DEV_IT821X with 2.6.30.2
Message-ID: <20090721004811.31a79a98@lxorguk.ukuu.org.uk>
In-Reply-To: <4A64F7BA.2030900@technicalogic.com>
References: <4A64F7BA.2030900@technicalogic.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jul 2009 18:03:22 -0500
Dwayne Rightler <drightler@technicalogic.com> wrote:

> Hello,
> 
> I have a ITE8212 PCI card and it does not seem to allow UDMA on the 
> drives attached.  The drives run at ATA100 under other controllers.

The old IDE driver support for IT821x has been somewhat broken for some
time. The drivers/ata (libata) driver should handle it fully. In smart
mode it's "IDE-ish" and the old IDE code really isn't flexible enough to
cope. With the "ATAPI BIOS" its a fairly normal controller so both drivers
ought to work.
