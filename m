Return-Path: <linux-kernel-owner+w=401wt.eu-S1031342AbXDZQUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031342AbXDZQUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 12:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031341AbXDZQUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 12:20:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:11069 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031340AbXDZQUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:20:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,455,1170662400"; 
   d="scan'208";a="237226146"
Message-ID: <4630D154.7050708@intel.com>
Date: Thu, 26 Apr 2007 09:20:36 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@osdl.org>
CC: Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Lennert Buytenhek <buytenh@wantstofly.org>,
       David Acker <dacker@roinet.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Netdev List <netdev@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [RFT] e100 driver on ARM
References: <44FC0261.6010807@garzik.org> <20060904123123.GB1285@xi.wantstofly.org> <460AF480.7050609@intel.com> <460B4BF2.1070803@roinet.com> <20070329141041.GA3510@csclub.uwaterloo.ca> <46239138.4040408@roinet.com> <20070417173507.GB5575@csclub.uwaterloo.ca> <4630AC02.7040706@roinet.com> <20070426135013.GA12154@xi.wantstofly.org> <4630C159.1060707@garzik.org> <4630C7D0.8030901@intel.com> <4630CEA9.6050100@garzik.org>
In-Reply-To: <4630CEA9.6050100@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Apr 2007 16:20:37.0922 (UTC) FILETIME=[D353A820:01C7881E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Kok, Auke wrote:
>> Jeff, I think I should just push the IO patch and the sbit code to 
>> Andrew and have it sit there. That is a vastly larger test resource than 
>> we currently can generate for this. If needed we just let is sit there 
>> for a whole release cycle before moving it to #upstream.
> 
> The sbit code has been in -mm via netdev-2.6.git#ALL for many months 
> now.  I am certainly open to adding any number of "for -mm only" style 
> patches that you wish to pass along, for /any/ driver: e100, e1000, ixgb.

I think we should then just bite the bullet and move it over to #upstream for 
2.6.22, that gives us another full release cycle to monitor it.

I'll post 2 patches in a second. the first is for upstream and allows the driver 
to run with an invalid mac address in case the user overrides the eeprom 
checksum (in which case the mac address could likely be wrong). The second one 
is the I/O mode patch and for Andrew (MM), allthough the I/O mode is disabled by 
default, so it should be safe to put in upstream as well, but I leave that up to 
you to decide.

Auke
