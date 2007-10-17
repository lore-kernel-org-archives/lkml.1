Return-Path: <linux-kernel-owner+w=401wt.eu-S935890AbXJQQjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935890AbXJQQjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 12:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759810AbXJQQjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 12:39:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:57402 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638AbXJQQjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 12:39:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,290,1188802800"; 
   d="scan'208";a="249311964"
Message-ID: <47163A95.1000708@intel.com>
Date: Wed, 17 Oct 2007 09:38:45 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070911)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Valdis.Kletnieks@vt.edu, 7eggert@gmx.de, prasad@linux.vnet.ibm.com,
       Pavel Machek <pavel@ucw.cz>, Arjan van de Ven <arjan@infradead.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: gigabit ethernet power consumption
References: <9c8XH-7gs-13@gated-at.bofh.it> <9c9qN-7Rn-19@gated-at.bofh.it> <9cs0n-3Dc-9@gated-at.bofh.it> <9csjH-43E-33@gated-at.bofh.it> <9d4yC-5hT-7@gated-at.bofh.it> <9d7ZJ-2mI-11@gated-at.bofh.it> <E1Ig9wz-0000sg-Ep@be1.lrz> <470FA243.6030908@intel.com> <12419.1192221016@turing-police.cc.vt.edu> <470FDD29.9030708@intel.com> <20071017130025.GN4000@csclub.uwaterloo.ca>
In-Reply-To: <20071017130025.GN4000@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Oct 2007 16:39:06.0128 (UTC) FILETIME=[3BBEF900:01C810DC]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> On Fri, Oct 12, 2007 at 01:46:33PM -0700, Kok, Auke wrote:
>> I would assume that that is true for all PHY's - if there is no link to keep the
>> carrier active on I would think that the power consumption is nominal across the
>> board. Once the PHY detects link pulses it should obviously use different power
>> levels to negotiate the link for each speed.
>>
>> PHY autonegotiation just works the same across the board - the PHY's send out
>> little pulses (iow nominal power consumption) to detect a link partner, and only
>> when one is found do they engage in more aggressive conversation to establish
>> capabilities across the link.
> 
> Too bad not much can be done about fibre ports, but then again you can't
> even change speeds on those.  Then again those are not on laptops or
> other low power devices in the first place.

the only thing we do for fiber ports is power off the laser if the user explicitly
powers them down at shutdown. Note that WoL needs to be disabled for that.

Auke
