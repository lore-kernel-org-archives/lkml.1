Return-Path: <linux-kernel-owner+w=401wt.eu-S1031187AbXDZPkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031187AbXDZPkH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 11:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031193AbXDZPkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 11:40:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:14334 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031187AbXDZPkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 11:40:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,455,1170662400"; 
   d="scan'208";a="219793010"
Message-ID: <4630C7D0.8030901@intel.com>
Date: Thu, 26 Apr 2007 08:40:00 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@osdl.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
CC: Lennert Buytenhek <buytenh@wantstofly.org>,
       David Acker <dacker@roinet.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Netdev List <netdev@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [RFT] e100 driver on ARM
References: <44FC0261.6010807@garzik.org> <20060904123123.GB1285@xi.wantstofly.org> <460AF480.7050609@intel.com> <460B4BF2.1070803@roinet.com> <20070329141041.GA3510@csclub.uwaterloo.ca> <46239138.4040408@roinet.com> <20070417173507.GB5575@csclub.uwaterloo.ca> <4630AC02.7040706@roinet.com> <20070426135013.GA12154@xi.wantstofly.org> <4630C159.1060707@garzik.org>
In-Reply-To: <4630C159.1060707@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Apr 2007 15:40:00.0596 (UTC) FILETIME=[26913940:01C78819]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Lennert Buytenhek wrote:
>> This is all a while ago now, but wasn't the e100 S-bit patch originally
>> written by Intel people in response to the very same quote by Russell
>> King that you've quoted above?
> 
> Correct.
> 
> I just wanted to make sure it didn't kill any boxes.

Neither did we. On top of that we didn't have the equipment to test on ARM on 
until recently, and the system that I got recently will not even load the kernel 
with an e100 NIC in the PCI slot (way way way before e100.ko loads, e1000 works 
just fine). that doesn't help either.

Meanwhile we've not sat still and jesse wrote a patch to have e100 use IO 
optionally for plagued platforms which seems to fix some of these issues, and 
Jeff Kirsher has been actively tracking a e100 IPMI issue on a very specific 
platform.

Jeff, I think I should just push the IO patch and the sbit code to Andrew and 
have it sit there. That is a vastly larger test resource than we currently can 
generate for this. If needed we just let is sit there for a whole release cycle 
before moving it to #upstream.

seems like a good idea, right?

Auke
