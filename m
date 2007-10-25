Return-Path: <linux-kernel-owner+w=401wt.eu-S1756190AbXJYH7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbXJYH7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 03:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbXJYH7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 03:59:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43272
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753459AbXJYH7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 03:59:36 -0400
Date: Thu, 25 Oct 2007 00:59:38 -0700 (PDT)
Message-Id: <20071025.005938.104394521.davem@davemloft.net>
To: Shane.Huang@amd.com
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org, barkalow@iabervon.org,
       linas@austin.ibm.com, gregkh@suse.de, htejun@gmail.com,
       brice.goglin@gmail.com, david.gaarenstroom@gmail.com,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-ide@vger.kernel.org,
       brice@myri.com, mchan@broadcom.com
Subject: Re: [PATCH 4/4]: [PCI]: Add MSI INTX_DISABLE quirks for ATI
 SB700/800 SATA and IXP SB400 USB
From: David Miller <davem@davemloft.net>
In-Reply-To: <5CAB7B5D6F8AB84AA868A46B47A507055D936C@sshaexmb1.amd.com>
References: <20071023.195343.35661973.davem@davemloft.net>
	<5CAB7B5D6F8AB84AA868A46B47A507055D936C@sshaexmb1.amd.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Shane Huang" <Shane.Huang@amd.com>
Date: Wed, 24 Oct 2007 14:43:21 +0800

> This patch and the third one seems can make my SB700 SATA controller
> work under MSI(simply tested on 2.6.23-rc5). 
> 
> So you may withdraw the RS690/RD580/RX790 MSI disablement patches
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commi
> t;h=4be8f906435a6af241821ab5b94b2b12cb7d57d8
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commi
> t;h=aea6a433f50cd89b9cbd10850fd0b32f961f9883
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commi
> t;h=f122392f679ebed39db08074f935d770504623eb
> after the commit of these MSI/INTx quirks.

Thank you for testing!

I will add this change to my patch set.
