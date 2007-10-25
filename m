Return-Path: <linux-kernel-owner+w=401wt.eu-S1757591AbXJYIYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbXJYIYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 04:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbXJYIYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 04:24:38 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60498 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115AbXJYIYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 04:24:37 -0400
Message-ID: <472052C1.2050302@garzik.org>
Date: Thu, 25 Oct 2007 04:24:33 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, barkalow@iabervon.org, linas@austin.ibm.com,
       chunhao.huang@hotmail.com, gregkh@suse.de, htejun@gmail.com,
       brice.goglin@gmail.com, david.gaarenstroom@gmail.com,
       linux-pci@atrey.karlin.mff.cuni.cz, shane.huang@amd.com,
       linux-ide@vger.kernel.org, brice@myri.com, mchan@broadcom.com
Subject: Re: [PATCH 0/5]: Resolve MSI vs. INTX_DISABLE quirks, V2.
References: <20071025.011445.80152909.davem@davemloft.net>
In-Reply-To: <20071025.011445.80152909.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> Ok, I've respun the patches including all of the feedback I've
> obtained.  Again, it's at:
> 
> 	kernel.org:/pub/scm/linux/kernel/git/davem/msiquirk-2.6.git
> 
> Greg, I think this stuff is ready to go so if you would pull
> them in I would really appreciate it.
> 
> These changes clean up the handling of the common quirk wherein
> setting INTX_DISABLE will mistakedly disable MSI generation for some
> devices.
> 
> For devices without that problem, we want to keep the pci_intx() calls
> in drivers/pci/msi.c because those help protect against devices with
> the opposite problem.  Such devices always generate INTX interrupts
> even when MSI is enabled, unless INTX_DISABLE is set.
> 
> In addition to the Tigon3 cases, I added quirk entries for the
> SB700/800 SATA chips and the IXP SB400 USB controllers.  And as
> a result of the latter we can remove several AMD full-chipset
> MSI disable quirks which are no longer necessary.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>

[corrected subject line s/4/5/.  the actual patches are OK]

Acked-by: Jeff Garzik <jgarzik@redhat.com>

