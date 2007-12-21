Return-Path: <linux-kernel-owner+w=401wt.eu-S1757327AbXLUFdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327AbXLUFdN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 00:33:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbXLUFdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 00:33:03 -0500
Received: from gate.crashing.org ([63.228.1.57]:36320 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbXLUFdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 00:33:01 -0500
Subject: Re: [PATCH 3/3] pci: Remove pci_enable_device_bars()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Greg KH <greg@kroah.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       ink@jurassic.park.msu.ru, Alan Cox <alan@redhat.com>,
       james.smart@emulex.com, linux-driver@qlogic.com,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
In-Reply-To: <20071221051139.GA23507@kroah.com>
References: <20071220042812.706D0DDEE7@ozlabs.org>
	 <20071221042855.GF25341@kroah.com> <1198212448.6779.45.camel@pasglop>
	 <20071221051139.GA23507@kroah.com>
Content-Type: text/plain
Date: Fri, 21 Dec 2007 16:32:11 +1100
Message-Id: <1198215131.6779.49.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-20 at 21:11 -0800, Greg KH wrote:
> On Fri, Dec 21, 2007 at 03:47:28PM +1100, Benjamin Herrenschmidt wrote:
> > pci: Remove pci_enable_device_bars() fix for qla
> > 
> > The previous patch missed one occurence of pci_enable_device_bars()
> > in the qla2xxx driver. This fixes it.
> 
> Should I just merge this with your 2/3 patch so everything is sane?

Sure.

Cheers,
Ben.

