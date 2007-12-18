Return-Path: <linux-kernel-owner+w=401wt.eu-S1752041AbXLRSlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbXLRSlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 13:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750777AbXLRSlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 13:41:16 -0500
Received: from host.infinivid.com ([64.119.179.76]:34642 "EHLO
	host.infinivid.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbXLRSlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 13:41:15 -0500
Subject: Re: PCI resource unavailable on mips
From: Jon Dufresne <jon.dufresne@infinitevideocorporation.com>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org, linux-mips <linux-mips@linux-mips.org>
In-Reply-To: <4761C26C.3010708@shaw.ca>
References: <fa.vbvzhsk+kDPCopbmajO8EsxAnKE@ifi.uio.no>
	 <4761C26C.3010708@shaw.ca>
Content-Type: text/plain
Date: Tue, 18 Dec 2007 13:40:43 -0500
Message-Id: <1198003243.3382.11.camel@microwave.infinitevideocorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Bar0:PHYS=e0000000 LEN=04000000
> > Bar1:PHYS=efa00000 LEN=00200000
> > Bar2:PHYS=e8000000 LEN=04000000
> 
> So, two 64MB BARs and a 2MB one?

That is right.

> Any PCI resource allocation errors in dmesg during the boot process? 
> Could be the kernel wasn't able to find a place to map all of the BARs.
> 

I went back and looked at the boot up messages and I found this:

PCI: Failed to allocate mem resource #2:4000000@24000000 for
0000:00:0c.0


That is my device. So it does appear that there is an allocation issue.
Any idea how to get around this?

Thanks,
Jon

