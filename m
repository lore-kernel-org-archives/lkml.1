Return-Path: <linux-kernel-owner+w=401wt.eu-S1759260AbXKNWRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260AbXKNWRc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 17:17:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753538AbXKNWRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 17:17:24 -0500
Received: from gate.crashing.org ([63.228.1.57]:37358 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465AbXKNWRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 17:17:23 -0500
Subject: Re: [PATCH] Align PCI memory regions to page size (4K) - Fix
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Grant Grundler <grundler@parisc-linux.org>
Cc: David Miller <davem@davemloft.net>, gregkh@suse.de, barak@neocleus.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       guy@neocleus.com
In-Reply-To: <20071114215538.GA14588@colo.lackof.org>
References: <20071028193104.GA13956@suse.de>
	 <9392A06CB0FDC847B3A530B3DC174E7B03C96F36@mse10be1.mse10.exchange.ms>
	 <20071028200336.GA14563@suse.de>
	 <20071028.180807.165828961.davem@davemloft.net>
	 <1194988653.28605.4.camel@pasglop> <20071114062157.GA30203@colo.lackof.org>
	 <1195028178.28865.32.camel@pasglop>
	 <20071114215538.GA14588@colo.lackof.org>
Content-Type: text/plain
Date: Thu, 15 Nov 2007 09:16:43 +1100
Message-Id: <1195078603.28865.51.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-11-14 at 14:55 -0700, Grant Grundler wrote:

> Ah ok.. I was assuming there was only a "Hypervisor" and all the "guests"
> were equal. If one OS instance is "Host" and can see the device before hand,
> then yeah, it makes sense to "hide" the device from the normal device drivers.

The "Host" is the hypervisor in something like KVM or lguest which is
all I really care about :-) On Xen, it would be dom0 I suppose.

Ben.


