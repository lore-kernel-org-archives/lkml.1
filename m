Return-Path: <linux-kernel-owner+w=401wt.eu-S933996AbXC0FXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933996AbXC0FXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 01:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933997AbXC0FXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 01:23:07 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60947 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933996AbXC0FXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 01:23:03 -0400
Message-ID: <4608AA30.1010407@garzik.org>
Date: Tue, 27 Mar 2007 01:22:56 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: David Miller <davem@davemloft.net>, bunk@stusta.de, gregkh@suse.de,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [RFC: 2.6.21 patch] let PCI_MSI depend on EXPERIMENTAL
References: <20070327010247.GW16477@stusta.de> <20070326.182422.115910859.davem@davemloft.net> <m14po71ir7.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m14po71ir7.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> aka.  Drivers have started supporting MSI, People have started using
> and testing MSI, and there has been MSI maintenance.  People care.

Agreed, well put.


> The most recent regressions involving MSI have been fixes propagating
> their way through the kernel, and I can't think of a one of them
> that was MSI specific.  Just that the bug didn't happen to show
> up clearly without MSI enabled.

Yep.


> So default it to off, although I suspect we are approaching the
> point where it would actually be safe to default it to on.  We
> need a kernel release that doesn't have msi issues yet.

Now that we are finally getting a handle on the MSI bumps-in-the-road, 
IMO it would be counterproductive to default it to 'off' now.

	Jeff


