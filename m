Return-Path: <linux-kernel-owner+w=401wt.eu-S1752098AbXKJFAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbXKJFAi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 00:00:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750774AbXKJFA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 00:00:29 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:51656 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbXKJFA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 00:00:28 -0500
Message-ID: <47353AE8.5050900@garzik.org>
Date: Sat, 10 Nov 2007 00:00:24 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: peer chen <peerchen@gmail.com>, Kuan Luo <kluo@nvidia.com>,
       Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] sata_nv,ahci: add the ahci legacy mode support to sata_nv
References: <200709251323031982245@gmail.com> <470FE47B.5060505@garzik.org>	 <cfaab6210710160108x1328086cse991f668e23e569e@mail.gmail.com>	 <47181CE1.4000802@garzik.org>	 <cfaab6210710182358t4de355f9wd6d605a7b8076ace@mail.gmail.com>	 <47185BFD.2010909@garzik.org> <cfaab6210710211855q7a2de35co13d3017b2a07d4cc@mail.gmail.com> <47352DD8.6040607@garzik.org>
In-Reply-To: <47352DD8.6040607@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> The proposed sata_nv patch does the opposite -- guarantees we must 
> support the continually problematic legacy IDE interface ad infinitum. 
> Such patches are OK for the test lab, but in this specific case users 
> /suffer/ when not running AHCI mode.

Just to reinforce...

sata_nv support and bug fixes are primarily done right now through the 
valiant efforts of Robert Hancock (with assists from Alan, Tejun, and 
others).

Robert's job is difficult, because he has no hardware documentation[1], 
and NVIDIA does not seem to be helping out much with driver bug reports 
on the lists or in bugzillas.

As far as I know, I am the only one in the universe outside of NVIDIA 
with any SATA docs at all, and those docs _only_ cover ADMA registers 
and DMA structures, no PCI config info, no errata, nothing on SWNCQ or 
legacy IDE (well, half a page).

NVIDIA has indeed become more engaged in sata_nv in recent times, and 
that's a positive sign.  You, Kuon and Ayaz have all been noticeably 
more responsive in email.  Thanks.  Users have definitely benefited, 
particularly from your help addressing a couple SWNCQ issues.

But at this point in time, being asked to choose between sata_nv and 
ahci is no choice at all.  One has public documentation, wide industry 
support and little-or-no bugs.  The other has several open issues, no 
documentation, and support obstacles.

	Jeff


[1] Robert, please correct me if I'm wrong...

