Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbXKJTBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbXKJTBB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 14:01:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbXKJTAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 14:00:52 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:23203 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbXKJTAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 14:00:51 -0500
Date: Sat, 10 Nov 2007 13:00:54 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] sata_nv,ahci: add the ahci legacy mode support to sata_nv
In-reply-to: <47353AE8.5050900@garzik.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: peer chen <peerchen@gmail.com>, Kuan Luo <kluo@nvidia.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Message-id: <4735FFE6.6020705@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <200709251323031982245@gmail.com> <470FE47B.5060505@garzik.org>
 <cfaab6210710160108x1328086cse991f668e23e569e@mail.gmail.com>
 <47181CE1.4000802@garzik.org>
 <cfaab6210710182358t4de355f9wd6d605a7b8076ace@mail.gmail.com>
 <47185BFD.2010909@garzik.org>
 <cfaab6210710211855q7a2de35co13d3017b2a07d4cc@mail.gmail.com>
 <47352DD8.6040607@garzik.org> <47353AE8.5050900@garzik.org>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Jeff Garzik wrote:
>> The proposed sata_nv patch does the opposite -- guarantees we must 
>> support the continually problematic legacy IDE interface ad infinitum. 
>> Such patches are OK for the test lab, but in this specific case users 
>> /suffer/ when not running AHCI mode.
> 
> Just to reinforce...
> 
> sata_nv support and bug fixes are primarily done right now through the 
> valiant efforts of Robert Hancock (with assists from Alan, Tejun, and 
> others).
> 
> Robert's job is difficult, because he has no hardware documentation[1], 
> and NVIDIA does not seem to be helping out much with driver bug reports 
> on the lists or in bugzillas.

Right, I don't have anything. Unless the original incomplete ADMA driver 
release from NVIDIA counts as documentation, lol.

And yes, I've CC'ed NVIDIA people about a few ADMA-related issues and 
been met with silence. It would be nice if they were as responsive about 
ADMA issues as I must say Kuan and Peer have been on the SWNCQ side of 
things..

> 
> As far as I know, I am the only one in the universe outside of NVIDIA 
> with any SATA docs at all, and those docs _only_ cover ADMA registers 
> and DMA structures, no PCI config info, no errata, nothing on SWNCQ or 
> legacy IDE (well, half a page).
> 
> NVIDIA has indeed become more engaged in sata_nv in recent times, and 
> that's a positive sign.  You, Kuon and Ayaz have all been noticeably 
> more responsive in email.  Thanks.  Users have definitely benefited, 
> particularly from your help addressing a couple SWNCQ issues.
> 
> But at this point in time, being asked to choose between sata_nv and 
> ahci is no choice at all.  One has public documentation, wide industry 
> support and little-or-no bugs.  The other has several open issues, no 
> documentation, and support obstacles.

They're not even equivalent interfaces in this case, in the proposed 
AHCI legacy mode patch these controllers are supported in the default 
SFF mode only, no ADMA or SWNCQ, so you don't get any NCQ support..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

