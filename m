Return-Path: <linux-kernel-owner+w=401wt.eu-S933575AbXHFWfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933575AbXHFWfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 18:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763315AbXHFWfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 18:35:37 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:53660 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762939AbXHFWfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 18:35:37 -0400
Date: Mon, 06 Aug 2007 16:35:25 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH 2.6.22.y] ieee1394: revert "sbp2: enforce	32bit	DMA	mapping"
In-reply-to: <1186439529.938.95.camel@localhost.localdomain>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Olaf Hering <olh@suse.de>,
       linuxppc-dev@ozlabs.org, stable@kernel.org,
       linux-kernel@vger.kernel.org
Message-id: <46B7A22D.4030909@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.Qn3Snqoik3hhnxcA6HqjGV0Yzck@ifi.uio.no>
 <46B4B3DC.7020609@shaw.ca> <46B4B7C6.1040107@s5r6.in-berlin.de>
 <1186272926.938.8.camel@localhost.localdomain>
 <46B5824B.1000103@s5r6.in-berlin.de>
 <1186351473.938.21.camel@localhost.localdomain>
 <20070806135124.GA2900@suse.de>
 <1186436848.938.75.camel@localhost.localdomain>
 <46B79F25.50205@s5r6.in-berlin.de> <46B79FD7.9020801@shaw.ca>
 <1186439529.938.95.camel@localhost.localdomain>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Mon, 2007-08-06 at 16:25 -0600, Robert Hancock wrote:
>>> Anyway.  For now I will simply go with what 2.6.23-rc has and what
>>> 2.6.21 had:  No dma_set_mask anywhere in the 1394 subsystem.  We can
>>> revisit this whenever an actual need arises.
>> Not sure this is a very good idea. This seems rather likely to fail on
>> x86_64 machines with >4GB of RAM for example.. 
> 
> Would it ? Isn't the default DMA mask for PCI devices set to 32 bits
> anyway ? In which case, swiotlb will take care of the matter.
> 
> Cheers,
> Ben.

Hmm, that's true, yes. Suppose it shouldn't be a problem then.

I would agree, though, that sbp2 isn't really the place for setting 
this, since the DMA mask is presently a property of the device, not of 
the user..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


