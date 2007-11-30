Return-Path: <linux-kernel-owner+w=401wt.eu-S934946AbXK3NSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934946AbXK3NSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 08:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbXK3NSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 08:18:20 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:49970 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755810AbXK3NST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 08:18:19 -0500
Message-ID: <47500D95.4020009@garzik.org>
Date: Fri, 30 Nov 2007 08:18:13 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: dsterba@suse.cz
CC: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       akpm@linux-foundation.org, jkosina@suse.cz, jslaby@suse.cz,
       stephen@symmetric.co.nz, benm@symmetric.co.nz
Subject: Re: [PATCH] ipwireless_cs driver for 4G PC Card
References: <20071130125555.GA10977@ds.suse.cz>
In-Reply-To: <20071130125555.GA10977@ds.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Sterba wrote:
> Hi,
> 
> I'm submitting driver for IPWireless PC Card, used for 4G
> internet connection.
> The driver has been in -mm series as ipwireless_cs.git tree for
> some time, is actively used and there are currently no
> outstanding bugs.
> 
> I'd like to let the driver pass through LKML and then let it
> queue for 2.6.25.
> 
> Driver is released under GPL, original authorship belongs to
> Symmetric co. Jiri Kosina has fixed some bugs and made it work
> with recent kernels, and I work on improving the code to
> match linux kernel standards.
> 
> When merged, please drop ipwireless_cs.git tree from -mm and
> include the patch instead. Patches should be sent to me and I'll
> push them to mainline via Jeff Garzik's driver tree, if there's
> no objection.
> 
> Driver lives in drivers/char/pcmcia directory, it's a serial
> driver.  I'm not sure if this is the right place, since it's a
> networking driver too and therefore should be in
> drivers/net/pcmcia.
> 
> There will be a wiki with info for users and developers, todo etc.

If the -main- purpose of the hardware is wireless, it should go in via 
John Linville, wireless maintainer...

	Jeff



