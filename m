Return-Path: <linux-kernel-owner+w=401wt.eu-S1763218AbXJRAXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763218AbXJRAXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 20:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760546AbXJRAXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 20:23:04 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49998 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759001AbXJRAXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 20:23:01 -0400
Message-ID: <4716A761.5040307@garzik.org>
Date: Wed, 17 Oct 2007 20:22:57 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>
CC: AAbdulla@nvidia.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-stable <stable@kernel.org>
Subject: Re: [PATCH] forcedeth msi bugfix
References: <200710171952.l9HJqXgq027920@colorfullife.mysite.adiungo.com>
In-Reply-To: <200710171952.l9HJqXgq027920@colorfullife.mysite.adiungo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Manfred Spraul wrote:
> pci_enable_msi() replaces the INTx irq number in pci_dev->irq with the
> new MSI irq number.
> The forcedeth driver did not update the copy in netdevice->irq and
> parts of the driver used the stale copy.
> See bugzilla.kernel.org, bug 9047.
> 
> The patch
> - updates netdevice->irq
> - replaces all accesses to netdevice->irq with pci_dev->irq.
> 
> The patch is against 2.6.23.1. IMHO suitable for both 2.6.23 and 2.6.24
> 
> Signed-Off-By: Manfred Spraul <manfred@colorfullife.com>

applied to upstream, after fixing the driver version (already bumped).

and I agree, stable@kernel.org should have this


