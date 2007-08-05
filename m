Return-Path: <linux-kernel-owner+w=401wt.eu-S1759117AbXHEHzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759117AbXHEHzZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 03:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbXHEHzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 03:55:16 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:50532 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549AbXHEHzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 03:55:15 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46B5824B.1000103@s5r6.in-berlin.de>
Date: Sun, 05 Aug 2007 09:54:51 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.5) Gecko/20070804 SeaMonkey/1.1.3
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Robert Hancock <hancockr@shaw.ca>, linuxppc-dev@ozlabs.org,
       Olaf Hering <olh@suse.de>, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.22.y] ieee1394: revert "sbp2: enforce 32bit DMA	mapping"
References: <fa.Qn3Snqoik3hhnxcA6HqjGV0Yzck@ifi.uio.no>	 <46B4B3DC.7020609@shaw.ca>  <46B4B7C6.1040107@s5r6.in-berlin.de> <1186272926.938.8.camel@localhost.localdomain>
In-Reply-To: <1186272926.938.8.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
>>> If setting 32-bit DMA mask fails on ppc64, that sounds like a problem
>>> with the DMA implementation on that architecture. There are enough cards
>>> out there that only support 32-bit DMA that this really needs to work..
>> Yes, could the PPC folks please have a look at it?  Thanks.
> 
> Smells like we may have a bug there. No worries though, all current PPC
> machines have an iommu that will not give out addresses above 32 bits
> anyway, but I'll double check what's up.
> 
> Do you see something in dmesg when that happens ?

There was nothing in Olaf's report, except for trouble in sbp2 _after_
the failure.  http://lkml.org/lkml/2007/8/1/344  (I don't have a PMac.)
-- 
Stefan Richter
-=====-=-=== =--- --=-=
http://arcgraph.de/sr/
