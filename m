Return-Path: <linux-kernel-owner+w=401wt.eu-S1752945AbYJBBdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbYJBBdv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 21:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbYJBBdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 21:33:40 -0400
Received: from mga06.intel.com ([134.134.136.21]:25140 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751807AbYJBBdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 21:33:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,347,1220252400"; 
   d="scan'208";a="342806789"
Message-ID: <48E424EB.1000204@linux.intel.com>
Date: Wed, 01 Oct 2008 18:33:31 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jesse Brandeburg <jesse.brandeburg@intel.com>, jeff@garzik.org,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Bruce Allan <bruce.w.allan@intel.com>
Subject: Re: [PATCH] e1000e: write protect ICHx NVM to prevent malicious write/erase
References: <20081002001830.5951.3123.stgit@jbrandeb-bw.jf.intel.com> <20081002001835.5951.82533.stgit@jbrandeb-bw.jf.intel.com> <alpine.LFD.2.00.0810011731350.3341@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810011731350.3341@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Wed, 1 Oct 2008, Jesse Brandeburg wrote:
>> From: Bruce Allan <bruce.w.allan@intel.com>
>>
>> Set the hardware to ignore all write/erase cycles to the GbE region in
>> the ICHx NVM.  This feature can be disabled by the WriteProtectNVM module
>> parameter (enabled by default) only after a hardware reset, but
>> the machine must be power cycled before trying to enable writes.
> 
> Thanks, applied.
> 
> One thing that I did notice when I looked at the driver is that I don't 
> see any serialization what-so-ever around a lot of the special accesses.
> 

there's quite a few of that yes.
These are all fixed afaik but these fixes are being queued for 2.6.28 rather than being snuck in late into .27
(the patches have been posted to lkml a few times the last week)
