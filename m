Return-Path: <linux-kernel-owner+w=401wt.eu-S967398AbXG3Qhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967398AbXG3Qhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967074AbXG3Qg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:36:26 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43777 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967145AbXG3QgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:36:24 -0400
Message-ID: <46AE1383.3050305@garzik.org>
Date: Mon, 30 Jul 2007 12:36:19 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: Jan-Bernd Themann <ossthema@de.ibm.com>, netdev <netdev@vger.kernel.org>,
       Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       David Miller <davem@davemloft.net>, Andrew Gallatin <gallatin@myri.com>
Subject: Re: [PATCH 2/4][RFC] lro: Kconfig and Makefile
References: <200707301724.45781.ossthema@de.ibm.com> <20070730172535.15993806@oldman.hamilton.local>
In-Reply-To: <20070730172535.15993806@oldman.hamilton.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> Why make this a user selectable option at all? Unless you want
> to deal with out of tree drivers (not my problem), it should be hidden
> to avoid having to explain an support it.


In this case it's an optional library kernel module.  That seems to be a 
common setup for library modules.  We do the same with CONFIG_MII and 
drivers/net/mii.ko as well.

Originally it was done purely in the Makefile, but that does not account 
for net drivers in sub-directories (or out of tree as you point out).

	Jeff


