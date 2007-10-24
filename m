Return-Path: <linux-kernel-owner+w=401wt.eu-S1757036AbXJXFdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036AbXJXFdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 01:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755020AbXJXFdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 01:33:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34887
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754851AbXJXFdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 01:33:31 -0400
Date: Tue, 23 Oct 2007 22:33:15 -0700 (PDT)
Message-Id: <20071023.223315.10295721.davem@davemloft.net>
To: michael@ellerman.id.au
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org, barkalow@iabervon.org,
       linas@austin.ibm.com, chunhao.huang@hotmail.com, gregkh@suse.de,
       htejun@gmail.com, brice.goglin@gmail.com, david.gaarenstroom@gmail.com,
       linux-pci@atrey.karlin.mff.cuni.cz, shane.huang@amd.com,
       linux-ide@vger.kernel.org, brice@myri.com, mchan@broadcom.com
Subject: Re: [PATCH 3/4]: [PCI]: Add quirk for devices which disable MSI
 when INTX_DISABLE is set.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1193203821.8788.4.camel@concordia>
References: <20071023.195310.131105752.davem@davemloft.net>
	<1193203821.8788.4.camel@concordia>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Ellerman <michael@ellerman.id.au>
Date: Wed, 24 Oct 2007 15:30:21 +1000

> That looks like 6 hunks doing exactly the same thing? What about
> creating a pci_intx_quirked() (or something) that checks the flag and
> then does/or does not call pci_intx().

Good idea, I'll add that to the patch.
