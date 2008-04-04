Return-Path: <linux-kernel-owner+w=401wt.eu-S1752925AbYDDVw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925AbYDDVw0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 17:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbYDDVwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 17:52:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:10805 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614AbYDDVwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 17:52:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,606,1199692800"; 
   d="scan'208";a="545935893"
Message-ID: <47F6A252.3020105@intel.com>
Date: Fri, 04 Apr 2008 14:49:06 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Jeff Garzik <jeff@garzik.org>,
       e1000-list <e1000-devel@lists.sourceforge.net>,
       NetDev <netdev@vger.kernel.org>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>, Greg KH <greg@kroah.com>,
       linux-pci maillist <linux-pci@atrey.karlin.mff.cuni.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [E1000-devel] [ANNOUNCE] e1000 to e1000e migration of PCI	Express
 devices
References: <47F69965.7030303@intel.com> <1207344669.26869.33.camel@nimitz.home.sr71.net>
In-Reply-To: <1207344669.26869.33.camel@nimitz.home.sr71.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Apr 2008 21:50:08.0270 (UTC) FILETIME=[D9795AE0:01C8969D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Fri, 2008-04-04 at 14:11 -0700, Kok, Auke wrote:
>> >From kernel 2.6.26 onward all *PCI Express* device IDs previously
>> supported by e1000 will be moving to the e1000e driver.  This includes
>> ich8 and ich9 onboard LAN, server 5000 platform onboard LAN (es2) and
>> 82571/2/3 chipset based adapters and variants.
>>
>> If you have not already enabled CONFIG_E1000E make sure that you do so.
>> You can already do this with 2.6.25.  From 2.6.26 on this change will be
>> required if you have such a device.
> 
> I've been bitten by one or two of these in the past.  Can we do
> something like this for a couple of releases?
> 
> Shouldn't this default the E1000E config option to the same thing that
> people have the E1000 set as?  It should catch the dumb people like me
> who's enter key gets held down during a 'make oldconfig'. :)

that discussion went into the bar and never came out again last time it was
proposed. I really do not want to have any more bandages around.

Also your patch will not help much since in 2.6.24 there already is a
CONFIG_E1000E option so we've passed the stage for many people where this hack
would work.

Auke

