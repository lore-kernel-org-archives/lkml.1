Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbXJXClg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbXJXClg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 22:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbXJXCl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 22:41:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38378
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752925AbXJXCl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 22:41:28 -0400
Date: Tue, 23 Oct 2007 19:41:55 -0700 (PDT)
Message-Id: <20071023.194155.112293423.davem@davemloft.net>
To: Shane.Huang@amd.com
Cc: david.gaarenstroom@gmail.com, linux-kernel@vger.kernel.org,
       linas@austin.ibm.com, gregkh@suse.de, htejun@gmail.com,
       brice.goglin@gmail.com, linux-pci@atrey.karlin.mff.cuni.cz,
       jgarzik@pobox.com
Subject: Re: [patch] PCI: disable MSI on more ATI NorthBridges
From: David Miller <davem@davemloft.net>
In-Reply-To: <5CAB7B5D6F8AB84AA868A46B47A507055D91F2@sshaexmb1.amd.com>
References: <BLU120-W12C06900EC932864CC13A8E2980@phx.gbl>
	<9783dadb0710201352p28969b4bs573d817d70b1fff7@mail.gmail.com>
	<5CAB7B5D6F8AB84AA868A46B47A507055D91F2@sshaexmb1.amd.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Shane Huang" <Shane.Huang@amd.com>
Date: Tue, 23 Oct 2007 18:56:03 +0800

> Also I wonder why the USB MSI patch is not added into kernel at last?
> Will it lead to other bugs?

Probably someone just needs to be more vocal and active in pushing it
to the USB subsystem maintainer(s).  I've even had trouble getting
even simple bug fixes integrated recently, so perhaps it will take a
few retransmits and some patience to get it included.

Anyways, thanks for bringing it to our attention.

Greg, can you at least devote a few minutes to going over that USB MSI
patch, giving it any obvious things it needs (perhaps some
pci_msi_enable() return value checks, for example, but may not be
needed at all in this case) and then stash it somewhere so it doesn't
get lost in the void?

Thanks.
