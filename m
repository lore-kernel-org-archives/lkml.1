Return-Path: <linux-kernel-owner+w=401wt.eu-S1758518AbZAUDjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518AbZAUDjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 22:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932150AbZAUDjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 22:39:19 -0500
Received: from rtr.ca ([76.10.145.34]:35031 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932133AbZAUDjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 22:39:17 -0500
Message-ID: <497698E2.7090807@rtr.ca>
Date: Tue, 20 Jan 2009 22:39:14 -0500
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Daniel Barkalow <barkalow@iabervon.org>
Cc: IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>, Jeff Garzik <jgarzik@pobox.com>,
       linux-pci@vger.kernel.org
Subject: Re: libata, devm_*, and MSI ?
References: <4975F5C1.8090107@rtr.ca> <alpine.LNX.1.00.0901201626090.19665@iabervon.org>
In-Reply-To: <alpine.LNX.1.00.0901201626090.19665@iabervon.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Barkalow wrote:
..
> Initially, the core didn't do anything, and some drivers implemented the 
> need-intx-off quirk; eventually this went into the core as the default 
> behavior. Then some drivers implemented the need-intx-on quirk. Then some 
> common drivers for different hardware turned out to need it both ways, and 
> the core got a real quirk for it. But not all of the drivers have dropped 
> the local setting stuff.
> 
> The right way to go is to do nothing in the driver and use quirks if you 
> need it.
..

Perfect, thanks.

Next.. who knows something about debugging MSI across PCI bridges ?
I've got a 64-bit box here, PCIe near the core, but with full PCI-X
slots on the far side of two bridges.

The kernel happily allows my driver to setup MSI, but the interrupts
never arrive.  So something somewhere in between is either

(1) not set up or quirked quite right, or
(2) one of the bridges won't pass MSI and we don't detect that.

I'll poke more at it later and post some info, if somebody out there
knows enough about this kind of thing to provide some basic hints.

Cheers!
