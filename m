Return-Path: <linux-kernel-owner+w=401wt.eu-S1765571AbXGYPV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765571AbXGYPV2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 11:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756708AbXGYPVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 11:21:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:5571 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753741AbXGYPVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 11:21:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,581,1175497200"; 
   d="scan'208";a="254622672"
Message-ID: <46A76A66.9000304@intel.com>
Date: Wed, 25 Jul 2007 08:21:10 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070623)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
       netdev@vger.kernel.org
Subject: Re: [-mm patch] one e1000 driver should be enough for everyone
References: <20070725040304.111550f4.akpm@linux-foundation.org> <20070725133650.GB3572@stusta.de> <46A754C7.9080004@garzik.org> <20070725144615.GC3572@stusta.de> <46A7669C.5010104@garzik.org>
In-Reply-To: <46A7669C.5010104@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jul 2007 15:21:11.0368 (UTC) FILETIME=[6EAC3480:01C7CECF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Adrian Bunk wrote:
>> I found the discussion, and Christoph's e1000e sounds like the best name 
>> ("new" doesn't say whether it's a new driver for old hardware or a 
>> driver for new hardware).
> 
> Yeah, I think "e1000new" is a lame name.

Moreover, Andrew should probably just drop this driver from -mm for now.

> e1000e is good, or even e1001e if we wanted even more symmetry :)

I'm working on "e1000e" right now...

>> No problem for me, but this obviously implies that global code in the 
>> new driver has to be renamed.
> 
> Yes.  A global namespace is a global namespace.

yes, these are some of the kinks I still need to address. Allthough minor, it's 
going to take me some time to get it to the first step before I want to submit 
it (patience :))

>> And please ensure that they will always support distinct PCI IDs, or 
>> there will be the following common pattern if both drivers support
>> a card:
> 
> IIRC I think Auke said there is some minor PCI ID overlap that must be 
> addressed in the transition.  Disappointing and it raises transition 
> issues, but that's the way the split falls out naturally AFAICS.

I'll submit it with only ich9 id's at first, but it will be able to drive (sysfs 
bind) to some other devices too. This allows me to keep an eye out on the future 
structure that I want to give it without removing too much code that I might 
then later have to add back.

Auke
