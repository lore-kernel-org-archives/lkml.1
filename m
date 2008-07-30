Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbYG3TVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbYG3TVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 15:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754495AbYG3TVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 15:21:34 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:30471 "EHLO
	pd5mo1no-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754492AbYG3TVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 15:21:33 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=dkSNLZc3JAWxmWpFRhoA:9 a=nz7t8EDBJrqaCecqCqpDuyP7W3UA:4
Message-ID: <4890BF39.6060608@shaw.ca>
Date: Wed, 30 Jul 2008 13:21:29 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: "V.Radhakrishnan" <rk@atr-labs.com>
CC: Sanka Piyaratna <cesanka@yahoo.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: PCIe device driver question
References: <fa.PmBLCqOb4Xo53y3W9hAdnsU50Og@ifi.uio.no> <fa.42mxuHHJP7XQmYeyxNoEC/NFUHA@ifi.uio.no>
In-Reply-To: <fa.42mxuHHJP7XQmYeyxNoEC/NFUHA@ifi.uio.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V.Radhakrishnan wrote:
>>> am testing this in an X86_64 architecture machine with 4 GB of RAM. I
>>> am able to successfully dma data into any memory (dma) address >
>>> 0x0000_0001_0000_0000.
> 
> How can you DMA "successfully" into this address which is > 4 GB when
> you have only 4 GB RAM ? Or am I missing something ?

The MMIO and other reserved memory space at the top of the 32-bit memory 
space will cause the top part of memory to be relocated above 4GB.
