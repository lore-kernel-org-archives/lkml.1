Return-Path: <linux-kernel-owner+w=401wt.eu-S966230AbXDDBRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966230AbXDDBRP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 21:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966229AbXDDBRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 21:17:15 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57401 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S966230AbXDDBRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 21:17:13 -0400
Date: Wed, 4 Apr 2007 02:19:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Miller <davem@davemloft.net>
Cc: paulus@samba.org, dwmw2@infradead.org, linuxppc-dev@ozlabs.org,
       benh@kernel.crashing.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
Message-ID: <20070404021924.71e87580@the-village.bc.nu>
In-Reply-To: <20070403.165518.55726194.davem@davemloft.net>
References: <1175610345.2665.15.camel@shinybook.infradead.org>
	<17938.57292.870224.132415@cargo.ozlabs.ibm.com>
	<20070403.165518.55726194.davem@davemloft.net>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I totally agree with Paul, the onboard serial device should get
> ttyS0 regardless of what hardare is used to drive it.

Thats between you and udev.

> Generalizing this minor number allocation for ttyS? might be the
> best way to handle this.

Again this is a udev issue. udev can certainly do a generic "all my
serial ports" listing.

