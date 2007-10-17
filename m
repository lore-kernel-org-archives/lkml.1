Return-Path: <linux-kernel-owner+w=401wt.eu-S932745AbXJQNAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745AbXJQNAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 09:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765189AbXJQNA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 09:00:27 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:54347 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764998AbXJQNA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 09:00:26 -0400
Date: Wed, 17 Oct 2007 09:00:25 -0400
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Valdis.Kletnieks@vt.edu, 7eggert@gmx.de, prasad@linux.vnet.ibm.com,
       Pavel Machek <pavel@ucw.cz>, Arjan van de Ven <arjan@infradead.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: gigabit ethernet power consumption
Message-ID: <20071017130025.GN4000@csclub.uwaterloo.ca>
References: <9c8XH-7gs-13@gated-at.bofh.it> <9c9qN-7Rn-19@gated-at.bofh.it> <9cs0n-3Dc-9@gated-at.bofh.it> <9csjH-43E-33@gated-at.bofh.it> <9d4yC-5hT-7@gated-at.bofh.it> <9d7ZJ-2mI-11@gated-at.bofh.it> <E1Ig9wz-0000sg-Ep@be1.lrz> <470FA243.6030908@intel.com> <12419.1192221016@turing-police.cc.vt.edu> <470FDD29.9030708@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470FDD29.9030708@intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 01:46:33PM -0700, Kok, Auke wrote:
> I would assume that that is true for all PHY's - if there is no link to keep the
> carrier active on I would think that the power consumption is nominal across the
> board. Once the PHY detects link pulses it should obviously use different power
> levels to negotiate the link for each speed.
> 
> PHY autonegotiation just works the same across the board - the PHY's send out
> little pulses (iow nominal power consumption) to detect a link partner, and only
> when one is found do they engage in more aggressive conversation to establish
> capabilities across the link.

Too bad not much can be done about fibre ports, but then again you can't
even change speeds on those.  Then again those are not on laptops or
other low power devices in the first place.

--
Len Sorensen
