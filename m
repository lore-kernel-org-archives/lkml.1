Return-Path: <linux-kernel-owner+w=401wt.eu-S1752658AbXIYJYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbXIYJYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 05:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbXIYJYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 05:24:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:52005 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbXIYJYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 05:24:34 -0400
Subject: Re: IDE broken on Pegasos PPC platform
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Matt Sealey <matt@genesi-usa.com>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <46F82BCF.1020702@genesi-usa.com>
References: <46F80BB1.7050902@redhat.com>  <46F82BCF.1020702@genesi-usa.com>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 19:24:25 +1000
Message-Id: <1190712265.31978.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-09-24 at 22:27 +0100, Matt Sealey wrote:
> Yeah I'll ack it if it matters, although I'd make a nit about the
> fixing of device tree entries in prom_init and have it moved to
> nvramrc or a Forth script or boot loader..
> 
> Pegasos IDE quirks have been "fixed" so many times now in Linux,
> this code's going to get reshuffled again in other changes, I
> think the device tree should be fixed at the firmware level and
> not in the kernel.

In that case though, OF contains correct values for the interrupts, it's
more of an issue related to the device being in legacy mode and the
pci_dev only carrying one interrupt anyway.

Ben.


