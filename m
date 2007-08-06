Return-Path: <linux-kernel-owner+w=401wt.eu-S1763921AbXHFWcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763921AbXHFWcm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 18:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbXHFWcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 18:32:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:59865 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302AbXHFWca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 18:32:30 -0400
Subject: Re: [PATCH 2.6.22.y] ieee1394: revert "sbp2: enforce
	32bit	DMA	mapping"
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Olaf Hering <olh@suse.de>,
       linuxppc-dev@ozlabs.org, stable@kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <46B79FD7.9020801@shaw.ca>
References: <fa.Qn3Snqoik3hhnxcA6HqjGV0Yzck@ifi.uio.no>
	 <46B4B3DC.7020609@shaw.ca> <46B4B7C6.1040107@s5r6.in-berlin.de>
	 <1186272926.938.8.camel@localhost.localdomain>
	 <46B5824B.1000103@s5r6.in-berlin.de>
	 <1186351473.938.21.camel@localhost.localdomain>
	 <20070806135124.GA2900@suse.de>
	 <1186436848.938.75.camel@localhost.localdomain>
	 <46B79F25.50205@s5r6.in-berlin.de>  <46B79FD7.9020801@shaw.ca>
Content-Type: text/plain
Date: Tue, 07 Aug 2007 08:32:09 +1000
Message-Id: <1186439529.938.95.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-06 at 16:25 -0600, Robert Hancock wrote:
> > Anyway.  For now I will simply go with what 2.6.23-rc has and what
> > 2.6.21 had:  No dma_set_mask anywhere in the 1394 subsystem.  We can
> > revisit this whenever an actual need arises.
> 
> Not sure this is a very good idea. This seems rather likely to fail on
> x86_64 machines with >4GB of RAM for example.. 

Would it ? Isn't the default DMA mask for PCI devices set to 32 bits
anyway ? In which case, swiotlb will take care of the matter.

Cheers,
Ben.


