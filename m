Return-Path: <linux-kernel-owner+w=401wt.eu-S1757150AbXLSVJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150AbXLSVJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 16:09:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753587AbXLSVIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 16:08:55 -0500
Received: from gate.crashing.org ([63.228.1.57]:53606 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580AbXLSVIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 16:08:54 -0500
Subject: Re: No dma_sync_* during pci_probe? (Sparc, post 2.6.22 regression)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, gregkh@suse.de, krh@bitplanet.net,
       linux1394-devel@lists.sourceforge.net
In-Reply-To: <4767A323.7090205@s5r6.in-berlin.de>
References: <bug-9160-4803@http.bugzilla.kernel.org/>
	 <47112797.7060003@s5r6.in-berlin.de>	<47670BDF.80409@s5r6.in-berlin.de>
	 <20071217.165032.41424988.davem@davemloft.net>
	 <4767A323.7090205@s5r6.in-berlin.de>
Content-Type: text/plain
Date: Thu, 20 Dec 2007 08:08:13 +1100
Message-Id: <1198098493.31714.2.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-12-18 at 11:38 +0100, Stefan Richter wrote:
> So, ohci->card.device is in fact &pci_dev->dev.
> 
> Also note:
>   - The very same code did not oops at this point in 2.6.22.  It only
>     started doing so in 2.6.23.
>   - There has been no other report of this kind for any other
>     architecture yet.  I would expect e.g. the PPC64 folks to report
>     bugs in our dma mappings eventually.

Ignore my previous message... if you are indeed passing &pci_dev->dev,
it should work.

Ben.


