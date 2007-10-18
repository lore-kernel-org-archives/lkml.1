Return-Path: <linux-kernel-owner+w=401wt.eu-S1764283AbXJRKTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764283AbXJRKTx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 06:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761271AbXJRKTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 06:19:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57896
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758842AbXJRKTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 06:19:44 -0400
Date: Thu, 18 Oct 2007 03:19:57 -0700 (PDT)
Message-Id: <20071018.031957.104033396.davem@davemloft.net>
To: Shane.Huang@amd.com
Cc: gregkh@suse.de, htejun@gmail.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, Henry.Su@amd.com,
       Libin.Yang@amd.com
Subject: Re: [patch] PCI: disable MSI on more ATI NorthBridges
From: David Miller <davem@davemloft.net>
In-Reply-To: <5CAB7B5D6F8AB84AA868A46B47A507055D8C1D@sshaexmb1.amd.com>
References: <5CAB7B5D6F8AB84AA868A46B47A507055D8C1D@sshaexmb1.amd.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Shane Huang" <Shane.Huang@amd.com>
Date: Thu, 18 Oct 2007 17:14:36 +0800

> More ATI North Bridges like RS780 can't do MSI like its predecessors
> in linux. Disable MSIs on them.
> 
> Signed-off-by: Shane Huang <shane.huang@amd.com>

Can we get some detail as to why these north bridges have to have MSI
disabled completely?  I can't believe that all 6 of these ATI
controllers which will now be listed in the quirk table cannot use MSI
at all.

I've discovered several cases where it was a buggy device or a driver
bug that caused someone to erroneously submit patches that disable MSI
completely for the bridge they were behind.

I don't want that to happen any more.  One way to prevent that is to
have a full detailed justification for the MSI disabling in the
changelog or in the comments for the MSI quirk.

Thank you.
