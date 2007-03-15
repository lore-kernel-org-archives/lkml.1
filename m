Return-Path: <linux-kernel-owner+w=401wt.eu-S1752787AbXCOKRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbXCOKRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 06:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbXCOKRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 06:17:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59091 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbXCOKRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 06:17:18 -0400
Date: Thu, 15 Mar 2007 11:17:13 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, gregkh@suse.de,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, michal.k.k.piotrowski@gmail.com,
       linux-ide@vger.kernel.org, tglx@linutronix.de,
       shemminger@linux-foundation.org, mlord@pobox.com,
       linux-pm@lists.osdl.org
Subject: Re: [PATCH/RFC] PCI prepare/activate instead of enable to avoid IRQ storm and rogue DMA access
Message-ID: <20070315101713.GA10114@one.firstfloor.org>
References: <20070314152302.GB15600@htj.dyndns.org> <p73fy878pmg.fsf@bingen.suse.de> <45F8B1FE.5060406@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F8B1FE.5060406@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Do you mean between disabling IRQ mechanisms and enabling PCI device in 
> pcim_prepare_device()?

Yes.

-Andi
