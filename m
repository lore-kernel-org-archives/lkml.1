Return-Path: <linux-kernel-owner+w=401wt.eu-S966395AbXJSH0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966395AbXJSH0N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 03:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbXJSHZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 03:25:57 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:42196 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700AbXJSHZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 03:25:56 -0400
Message-ID: <47185BFD.2010909@garzik.org>
Date: Fri, 19 Oct 2007 03:25:49 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: peer chen <peerchen@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       Kuan Luo <kluo@nvidia.com>
Subject: Re: [PATCH] sata_nv,ahci: add the ahci legacy mode support to sata_nv
References: <200709251323031982245@gmail.com> <470FE47B.5060505@garzik.org>	 <cfaab6210710160108x1328086cse991f668e23e569e@mail.gmail.com>	 <47181CE1.4000802@garzik.org> <cfaab6210710182358t4de355f9wd6d605a7b8076ace@mail.gmail.com>
In-Reply-To: <cfaab6210710182358t4de355f9wd6d605a7b8076ace@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

peer chen wrote:
> Ok,I agree to use AHCI driver for our AHCI controllers no matter their
> class codes are IDE/RAID/AHCI. But for those new or upcoming AHCI
> controller which DIDs are not included in ahci.c and also IDE/RAID
> mode being set in BIOS, no driver will be loaded currently, so I hope
> the first patch http://lkml.org/lkml/2007/10/8/93 can be appied for
> this case. Any comments?

hmmm is that the correct URL?  That one updates sata_nv to support AHCI 
controllers?.

I would think you would want to add the RAID class code to ahci.c 
instead?  And just some regular PCI IDs?

	Jeff


