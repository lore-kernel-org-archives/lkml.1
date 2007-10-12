Return-Path: <linux-kernel-owner+w=401wt.eu-S1759942AbXJLUrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759942AbXJLUrE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 16:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757127AbXJLUqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 16:46:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:48422 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756554AbXJLUqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 16:46:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,268,1188802800"; 
   d="scan'208";a="171216803"
Message-ID: <470FDD29.9030708@intel.com>
Date: Fri, 12 Oct 2007 13:46:33 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070911)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: 7eggert@gmx.de, prasad@linux.vnet.ibm.com,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Pavel Machek <pavel@ucw.cz>, Arjan van de Ven <arjan@infradead.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: gigabit ethernet power consumption
References: <9c8XH-7gs-13@gated-at.bofh.it> <9c9qN-7Rn-19@gated-at.bofh.it> <9cs0n-3Dc-9@gated-at.bofh.it> <9csjH-43E-33@gated-at.bofh.it> <9d4yC-5hT-7@gated-at.bofh.it> <9d7ZJ-2mI-11@gated-at.bofh.it> <E1Ig9wz-0000sg-Ep@be1.lrz>            <470FA243.6030908@intel.com> <12419.1192221016@turing-police.cc.vt.edu>
In-Reply-To: <12419.1192221016@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Oct 2007 20:46:46.0870 (UTC) FILETIME=[015F7F60:01C80D11]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Fri, 12 Oct 2007 09:35:15 PDT, "Kok, Auke" said:
> 
>>> How much power does a non-connected NIC consume, and can you save power
>>> by forcing 10 MBit until a link is detected (doubling negotiation time)?
>> no, the PHY consumes a minimal amount of energy when not connected, regardless of
>> whether it is advertising 10, 100 or 1000mbit.
> 
> Is that true for essentially all the chipsets we support (or at least "the vast
> majority of the ones currently found in common machines")?

I would assume that that is true for all PHY's - if there is no link to keep the
carrier active on I would think that the power consumption is nominal across the
board. Once the PHY detects link pulses it should obviously use different power
levels to negotiate the link for each speed.

PHY autonegotiation just works the same across the board - the PHY's send out
little pulses (iow nominal power consumption) to detect a link partner, and only
when one is found do they engage in more aggressive conversation to establish
capabilities across the link.


Auke
