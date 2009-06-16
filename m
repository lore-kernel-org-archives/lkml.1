Return-Path: <linux-kernel-owner+w=401wt.eu-S1757241AbZFPD1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241AbZFPD1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 23:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbZFPD1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 23:27:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:43832 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473AbZFPD1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 23:27:30 -0400
Subject: Re: UIO: uio_mem does not handle devices above 4 GB address
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Steven A. Falco" <sfalco@harris.com>
Cc: linux-kernel@vger.kernel.org, hjk@linutronix.de,
       "Herrera-Bendezu, Luis" <lherrera@harris.com>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>
In-Reply-To: <49D4BB9F.8050903@harris.com>
References: <49D4BB9F.8050903@harris.com>
Content-Type: text/plain
Date: Tue, 16 Jun 2009 13:25:58 +1000
Message-Id: <1245122758.12400.52.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 09:20 -0400, Steven A. Falco wrote:

> struct uio_mem {
> 	phys_addr_t		addr;
> 	phys_addr_t		size;
> 	int			memtype;
> 	void __iomem		*internal_addr;
> 	struct uio_map		*map;
> };
> 
> A few other changes would be needed.  We'd have to use something
> other than

Use a struct resource instead.

> 	return sprintf(buf, "0x%lx\n", mem->addr);
> 

The struct resource has a printk format string.

Cheers,
Ben.
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev

