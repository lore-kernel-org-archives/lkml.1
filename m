Return-Path: <linux-kernel-owner+w=401wt.eu-S1753705AbXDCX46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbXDCX46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 19:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbXDCX46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 19:56:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36614
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753701AbXDCX45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 19:56:57 -0400
Date: Tue, 03 Apr 2007 16:56:57 -0700 (PDT)
Message-Id: <20070403.165657.34759233.davem@davemloft.net>
To: dwmw2@infradead.org
Cc: paulus@samba.org, linuxppc-dev@ozlabs.org, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1175642916.10567.24.camel@shinybook.infradead.org>
References: <1175610345.2665.15.camel@shinybook.infradead.org>
	<17938.57292.870224.132415@cargo.ozlabs.ibm.com>
	<1175642916.10567.24.camel@shinybook.infradead.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>
Date: Tue, 03 Apr 2007 19:28:36 -0400

> Abusing the 8250 device numbers prevents the 8250 module from being
> loaded at the same time as pmac_zilog, and means you can't have both
> internal port and PCMCIA or PCI 8250 ports active at the same time.

Dynamic minor number allocation for ttyS? would allow this
just fine, and that's exactly what we do on sparc as I
explained in another response.
