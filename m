Return-Path: <linux-kernel-owner+w=401wt.eu-S1753071AbYI3Dmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbYI3Dmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 23:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbYI3Dmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 23:42:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:57401 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbYI3Dmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 23:42:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,334,1220252400"; 
   d="scan'208";a="621772031"
Date: Mon, 29 Sep 2008 20:42:43 -0700 (Pacific Daylight Time)
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Arjan van de Ven <arjan@infradead.org>, Dave Airlie <airlied@gmail.com>,
       Jiri Kosina <jkosina@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jesse.brandeburg@intel.com
Subject: Re: Linux 2.6.27-rc8
In-Reply-To: <alpine.LFD.2.00.0809291921310.3389@nehalem.linux-foundation.org>
Message-ID: <Pine.WNT.4.63.0809292040140.2188@jbrandeb-desk.amr.corp.intel.com>
References: <alpine.LFD.2.00.0809291527460.3389@nehalem.linux-foundation.org>
 <Pine.LNX.4.64.0809300125460.2307@twin.jikos.cz>
 <alpine.LFD.2.00.0809291855000.3389@nehalem.linux-foundation.org>
 <21d7e9970809291859s5bff81e3ue0f63402c2ad422d@mail.gmail.com>
 <20080929190612.111f16ac@infradead.org> <alpine.LFD.2.00.0809291921310.3389@nehalem.linux-foundation.org>
ReplyTo: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
X-X-Sender: jesse.brandeburg@intel.com@imap.glb.intel.com
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2008, Linus Torvalds wrote:
> Btw, the _real_ bug is clearly in the hardware design that allows you to 
> brick those things without apparently even having a lock bit.

The hardware has a lock bit, and we're trying to figure out why the BIOS 
writers guide doesn't say to set it.  Probably because of the MAC address, 
but who knows.
 
> I'm hoping Intel doesn't treat this as just a software bug. Some hw 
> designer should be thinking hard about which orifice they put their head 
> up in.

We will post a patch to e1000e tomorrow that sets a lock bit that prevents 
the registers memory mapped by 0:19.0 BAR1 from causing flash write 
cycles.

The patches I've just posted don't quite do that yet.
