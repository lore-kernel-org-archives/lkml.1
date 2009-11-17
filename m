Return-Path: <linux-kernel-owner+w=401wt.eu-S1755465AbZKQSv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbZKQSv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 13:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754289AbZKQSvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 13:51:24 -0500
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:45275 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbZKQSvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 13:51:23 -0500
Message-ID: <4B02F050.2080100@csr.com>
Date: Tue, 17 Nov 2009 18:49:52 +0000
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Greg KH <greg@kroah.com>, lud <linux-usb@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 2 (usb/whci)
References: <20091102173845.210d1c57.sfr@canb.auug.org.au>	<20091102091339.479a3ddb.randy.dunlap@oracle.com>	<20091111090403.5fb0229e.randy.dunlap@oracle.com>	<20091111173015.GA9641@kroah.com>	<4B028BBB.1080803@csr.com> <20091117075101.0bf72415.randy.dunlap@oracle.com>
In-Reply-To: <20091117075101.0bf72415.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Nov 2009 18:49:52.0676 (UTC) FILETIME=[BF6CAE40:01CA67B6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> 
> When the driver is built-in (not a loadable module), the messages are:
> 
> drivers/built-in.o: In function `qset_add_urb':
> (.text+0x4595f8): undefined reference to `__umoddi3'
> drivers/built-in.o: In function `qset_add_urb':
> (.text+0x45969a): undefined reference to `__udivdi3'
> 
> Those could still refer to other (inline) functions...

If HIGHMEM64G is set then dma_addr_t is 64 bits which is where the 64
bit maths come from.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/


Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
