Return-Path: <linux-kernel-owner+w=401wt.eu-S966791AbXG3RBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966791AbXG3RBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 13:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965668AbXG3RBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 13:01:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:49997 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965543AbXG3RBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 13:01:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,199,1183359600"; 
   d="scan'208";a="274420863"
Message-ID: <46AE192E.4080205@intel.com>
Date: Mon, 30 Jul 2007 10:00:30 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070623)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Stephen Hemminger <shemminger@linux-foundation.org>,
       Jan-Bernd Themann <ossthema@de.ibm.com>,
       netdev <netdev@vger.kernel.org>, Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       David Miller <davem@davemloft.net>, Andrew Gallatin <gallatin@myri.com>
Subject: Re: [PATCH 2/4][RFC] lro: Kconfig and Makefile
References: <200707301724.45781.ossthema@de.ibm.com> <20070730172535.15993806@oldman.hamilton.local> <46AE1383.3050305@garzik.org>
In-Reply-To: <46AE1383.3050305@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jul 2007 17:01:04.0704 (UTC) FILETIME=[370B7400:01C7D2CB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Stephen Hemminger wrote:
>> Why make this a user selectable option at all? Unless you want
>> to deal with out of tree drivers (not my problem), it should be hidden
>> to avoid having to explain an support it.
> 
> In this case it's an optional library kernel module.  That seems to be a 
> common setup for library modules.  We do the same with CONFIG_MII and 
> drivers/net/mii.ko as well.
> 
> Originally it was done purely in the Makefile, but that does not account 
> for net drivers in sub-directories (or out of tree as you point out).

speaking of that, shouldn't there be a NETIF_F_LRO ?

Auke
