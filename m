Return-Path: <linux-kernel-owner+w=401wt.eu-S1760849AbYEPSmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760849AbYEPSmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 14:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760074AbYEPSmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 14:42:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:26603 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758969AbYEPSl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 14:41:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,498,1204531200"; 
   d="scan'208";a="329167722"
Message-ID: <482DD50C.2070601@intel.com>
Date: Fri, 16 May 2008 11:40:12 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080417)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Jeff Garzik <jeff@garzik.org>, Rick Jones <rick.jones2@hp.com>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       Chris Peterson <cpeterso@cpeterso.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net: remove network drivers' last few uses of
 IRQF_SAMPLE_RANDOM
References: <Pine.LNX.4.62.0805150009060.18303@ikari.dreamhost.com>	<20080515142154.0595e475@core>	<36D9DB17C6DE9E40B059440DB8D95F52052D71BB@orsmsx418.amr.corp.intel.com>	<482C7B18.6060003@garzik.org>	<482C7E53.3050300@hp.com>	<482C8184.2030906@garzik.org>	<482C8550.5000909@intel.com>	<482C8D4D.3040702@garzik.org>	<20080516132107.GA11304@csclub.uwaterloo.ca>	<20080516161029.44ded734@core>	<20080516173610.GA27126@csclub.uwaterloo.ca> <20080516191125.46f59ad6@core>
In-Reply-To: <20080516191125.46f59ad6@core>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> So what is one to do if a few applications want to read from /dev/random
>> but you have no excellent source of entropy on the system?  Wait
>> forever?  
> 
> Yes.
> 
> If they don't need that level of security they can use /dev/urandom.
> Piping network randomness into /dev/urandom is probably quite sensible
> but not into /dev/random.

I remember Jesse telling that he had this very same experience while installing a
RH box on a headless system with a serial console - a box prompted the user to
rattle a keyboard in order for the ssh key generation to continue :)

you absolutely don't want to use urandom for that I assume, but if the system just
sits dead waiting for randomness, and you can't see the popup asking for some
entropy, you're pretty much screwed :)

Auke

