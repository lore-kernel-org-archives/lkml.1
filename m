Return-Path: <linux-kernel-owner+w=401wt.eu-S1751859AbYENUXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859AbYENUXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 16:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbYENUXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 16:23:10 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:30939 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbYENUXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 16:23:09 -0400
Date: Wed, 14 May 2008 13:17:49 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: akpm <akpm@linux-foundation.org>, lkml <linux-kernel@vger.kernel.org>
Cc: linux-next@vger.kernel.org, david.vrabel@csr.com, greg@kroah.com
Subject: Re: uwb build errors: CONFIG_PCI=n, CONFIG_USB=y
Message-Id: <20080514131749.17675ba0.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0805061356150.17702@shark.he.net>
References: <Pine.LNX.4.64.0805061356150.17702@shark.he.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[dropped closed list: linux-uwb@bughost.org]

This build error has now moved into 2.6.26-rc2-mm1 also.


On Tue, 6 May 2008 13:58:22 -0700 (PDT) Randy.Dunlap wrote:

> 
> On x86_64 or i386, maybe others:
> 
> In file included from /home/rdunlap/linsrc/next-20080506/drivers/uwb/umc-bus.c:12:
> /home/rdunlap/linsrc/next-20080506/include/linux/uwb/umc.h: In function 'umc_parent_pci_dev':
> /home/rdunlap/linsrc/next-20080506/include/linux/uwb/umc.h:145: error: 'pci_bus_type' undeclared (first use in this function)
> /home/rdunlap/linsrc/next-20080506/include/linux/uwb/umc.h:145: error: (Each undeclared identifier is reported only once
> /home/rdunlap/linsrc/next-20080506/include/linux/uwb/umc.h:145: error: for each function it appears in.)
> /home/rdunlap/linsrc/next-20080506/drivers/uwb/umc-bus.c: In function 'umc_match_pci_id':
> /home/rdunlap/linsrc/next-20080506/drivers/uwb/umc-bus.c:29: error: 'pci_bus_type' undeclared (first use in this function)
> /home/rdunlap/linsrc/next-20080506/drivers/uwb/umc-bus.c:33: error: implicit declaration of function 'pci_match_id'
> make[3]: *** [drivers/uwb/umc-bus.o] Error 1
> make[2]: *** [drivers/uwb] Error 2



---
~Randy
