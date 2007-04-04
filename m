Return-Path: <linux-kernel-owner+w=401wt.eu-S966223AbXDDBO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966223AbXDDBO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 21:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966224AbXDDBO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 21:14:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:42657 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966225AbXDDBO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 21:14:57 -0400
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
Cc: dwmw2@infradead.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070403.165657.34759233.davem@davemloft.net>
References: <1175610345.2665.15.camel@shinybook.infradead.org>
	 <17938.57292.870224.132415@cargo.ozlabs.ibm.com>
	 <1175642916.10567.24.camel@shinybook.infradead.org>
	 <20070403.165657.34759233.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 11:13:58 +1000
Message-Id: <1175649238.30879.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-03 at 16:56 -0700, David Miller wrote:
> From: David Woodhouse <dwmw2@infradead.org>
> Date: Tue, 03 Apr 2007 19:28:36 -0400
> 
> > Abusing the 8250 device numbers prevents the 8250 module from being
> > loaded at the same time as pmac_zilog, and means you can't have both
> > internal port and PCMCIA or PCI 8250 ports active at the same time.
> 
> Dynamic minor number allocation for ttyS? would allow this
> just fine, and that's exactly what we do on sparc as I
> explained in another response.

If we can get it past whoever is the current 8250 maintainer, then fine
with me. Back then, I hit a brick wall.

Ben.


