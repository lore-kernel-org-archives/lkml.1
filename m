Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbYIYUpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbYIYUpY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 16:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753978AbYIYUpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 16:45:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:22128 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736AbYIYUpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 16:45:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,309,1220252400"; 
   d="scan'208";a="620367734"
Message-ID: <48DBF84D.6020905@intel.com>
Date: Thu, 25 Sep 2008 13:45:01 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080626)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Kyle McMartin <kyle@mcmartin.ca>, David Miller <davem@davemloft.net>,
       airlied@gmail.com, jeffrey.t.kirsher@intel.com, david.vrabel@csr.com,
       rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, chrisl@vmware.com
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
References: <alpine.LNX.1.10.0809240014390.4671@pegasus.suse.cz> <20080923.211215.193696086.davem@davemloft.net> <21d7e9970809232245x6a91c6e2l552ff039d07e2017@mail.gmail.com> <20080924.003638.71148740.davem@davemloft.net> <20080924191022.GC2591@phobos.i.cabal.ca> <alpine.LNX.1.10.0809250036090.4671@pegasus.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0809250036090.4671@pegasus.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Sep 2008 20:45:02.0917 (UTC) FILETIME=[95944750:01C91F4F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Wed, 24 Sep 2008, Kyle McMartin wrote:
> 
>> I've been working on a patch to detect (using a timer and checking at
>>  up/down) whether or not the flash has been corrupted, and, if it is
>> rewrite it with the saved good copy (which obviously only helps if
>> it's the same boot.)
> 
> Thanks, looks interesting e1000e hack that might possibly be of some help.
> 
> BUT! please have a look at
> 
> 	http://lkml.org/lkml/2008/9/24/133
> 
> Looks like this device got a lot of 0xff written somewhere in its config 
> space, right? But it isn't Intel card at all.

I asked that person and he said reverting to an older kernel made it work again,
also there is a fix out as romieu pointed out as well, so this seems to be a
different bug for now.

Auke
