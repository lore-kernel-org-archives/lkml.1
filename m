Return-Path: <linux-kernel-owner+w=401wt.eu-S1762935AbXIMDiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762935AbXIMDiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 23:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757631AbXIMDiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 23:38:17 -0400
Received: from trinity.phys.uwm.edu ([129.89.57.159]:57929 "EHLO
	trinity.phys.uwm.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757826AbXIMDiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 23:38:16 -0400
Date: Wed, 12 Sep 2007 22:37:56 -0500 (CDT)
From: Bruce Allen <ballen@gravity.phys.uwm.edu>
X-X-Sender: ballen@trinity.phys.uwm.edu
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       Robert Hancock <hancockr@shaw.ca>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Bruce Allen <bruce.allen@aei.mpg.de>
Subject: Re: ECC and DMA to/from disk controllers
In-Reply-To: <46E5EAB9.9020504@shaw.ca>
Message-ID: <Pine.LNX.4.63.0709122215100.16468@trinity.phys.uwm.edu>
References: <fa.qDlrttL6xIyU0yqEbWvsJiyy5tU@ifi.uio.no> <46E5EAB9.9020504@shaw.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan, Robert, Dick,

Thank you all for the informed and helpful response!

Alan, I'll pass your comments on to Peter Kelemen.  Not sure if he follows 
LKML.  I think he'll be interested in your characterization of the error 
types.  I'll point him to the thread.  (I think Peter and his 
collaborators are fairly aware of the undetected error rates in standard 
ethernet TCP/IP traffic which as I recall is about one undetected 
single-bit error per 4TB transfered.  I am pretty sure they have ruled 
this out since they have checksums computed after any network transfers.)

Robert, Dick, if I have understood correctly, in response to my specific 
question, RAID controllers on PCI cards will DMA data into memory over a 
PCI bus using one parity bit per 32 data bits for protection.  This does 
provide some protection against errors in the data transfer, but much less 
protection than typical RAM ECC which has one ECC byte for each eight data 
bytes. As I recall, many older motherboards disabled parity on the PCI 
bus, so even this protection may be inactive in many cases. From a few 
minutes of on-line research, I have the impression that PCI-e has better 
ECC protection against address/data errors than PCI but I am not certain.

Thanks again!

Cheers,
 	Bruce
