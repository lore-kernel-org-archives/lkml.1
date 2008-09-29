Return-Path: <linux-kernel-owner+w=401wt.eu-S1752096AbYI2RX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbYI2RX1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 13:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbYI2RXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 13:23:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:48001 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688AbYI2RXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 13:23:10 -0400
Date: Mon, 29 Sep 2008 10:23:25 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Grant Grundler <grundler@parisc-linux.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: introduce users of ioremap_pcibar()
Message-ID: <20080929102325.0ca5c0c9@infradead.org>
In-Reply-To: <20080929171049.GA14409@colo.lackof.org>
References: <20080926163641.288bf868@infradead.org>
	<20080926163718.32f0867e@infradead.org>
	<20080929072643.GA28871@colo.lackof.org>
	<20080929064220.374c68a4@infradead.org>
	<20080929171049.GA14409@colo.lackof.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2008 11:10:49 -0600
Grant Grundler <grundler@parisc-linux.org> wrote:

> And I have to agree with willy/alan, pci_iomap() is already doing
> this.

pci_iomap() does "stuff" but it assumes you're using the iomap APIs
across the driver. MANY don't.

And pci_iomap() takes more parameters than most driver writers want or
need. Most of the time it's "I want the whole bar"; even if my patch
wraps around that, making the API simpler is still worth it imo
