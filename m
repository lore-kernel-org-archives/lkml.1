Return-Path: <linux-kernel-owner+w=401wt.eu-S1760200AbXI1AnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760200AbXI1AnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 20:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756896AbXI1AnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 20:43:08 -0400
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:26577 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbXI1AnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 20:43:07 -0400
DomainKey-Signature: s=smtpout; d=dell.com; c=nofws; q=dns; b=GxhWJzNKJMABa4idYr0ISw36UdoIjAH5RF1fBwfq033kig2ya5CUdUsEfrUAdXbD7eIpAsMGzIRjmY9jYK5e6kYskrM/bLum1OOlbph5KqZfvcBRBtWkYH+ZTHnPKCjb;
X-IronPort-AV: E=Sophos;i="4.21,206,1188795600"; 
   d="scan'208";a="356916115"
Date: Thu, 27 Sep 2007 19:43:02 -0500
From: Matt Domsch <Matt_Domsch@dell.com>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: linux-kernel@vger.kernel.org, john.cagle@hp.com,
       Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCH] pci: use pci=bfsort for HP DL385 G2, DL585 G2
Message-ID: <20070928004302.GB12138@auslistsprd01.us.dell.com>
References: <46FB7574.7060608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46FB7574.7060608@redhat.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 11:18:44AM +0200, Michal Schmidt wrote:
> Hello,
> 
> HP ProLiant systems DL385 G2 and DL585 G2 need pci=bfsort to enumerate PCI
> devices in the expected order.
> 
> (John, can you please confirm and ACK this?)

As a shameless plug, biosdevname is a userspace app I wrote to help
solve this so we don't need to patch the kernel for future systems.
It's not integrated into any distributions properly yet, but is
included in openSUSE 10.3 and Fedora 8 for people who want to download
and install it there.  It acts as a udev helper.

For the time being, patching the kernel is necessary.  I really hope
biosdevname eliminates that need in future distributions.

http://linux.dell.com/biosdevname/

Thanks,
Matt

-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
