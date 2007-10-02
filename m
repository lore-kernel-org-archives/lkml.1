Return-Path: <linux-kernel-owner+w=401wt.eu-S1753609AbXJBPUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbXJBPUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 11:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbXJBPUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 11:20:44 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50723 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761AbXJBPUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 11:20:43 -0400
Message-ID: <470261C9.3000700@garzik.org>
Date: Tue, 02 Oct 2007 11:20:41 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm] libata: add human-readable error value decoding v3
References: <46B36D59.7060803@shaw.ca>
In-Reply-To: <46B36D59.7060803@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> This adds human-readable decoding of the ATA status and error registers
> (similar to what drivers/ide does) as well as the SATA Serror register to
> libata error handling output.  This prevents the need to pore through
> standards documents to figure out the meaning of the bits in these
> registers when looking at error reports.  Some bits that drivers/ide
> decoded are not decoded here, since the bits are either command-dependent
> or obsolete, and properly parsing them would add too much complexity.
> 
> Signed-off-by: Robert Hancock <hancockr@shaw.ca>
> 
> ---
> 
> Rebased to apply to 2.6.23-rc1-mm2.

I'm applying this manually....   sorry it took so long, the asymmetry of 
"{DRDY }" bugged me, so I did a few cleanups.


