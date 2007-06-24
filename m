Return-Path: <linux-kernel-owner+w=401wt.eu-S1755194AbXFXJju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194AbXFXJju (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 05:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbXFXJjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 05:39:43 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54498 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946AbXFXJjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 05:39:42 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <467E3BA8.4050505@s5r6.in-berlin.de>
Date: Sun, 24 Jun 2007 11:38:48 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "Huang, Ying" <ying.huang@intel.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Adrian Bunk <bunk@stusta.de>,
       "david@lang.hm" <david@lang.hm>, David Miller <davem@davemloft.net>,
       "bunk@stusta.de; Duncan Sands" <duncan.sands@math.u-psud.fr>,
       Phillip Susi <psusi@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] driver core: multithreaded probing - more parallelism
 control
References: <1182373258.30574.30.camel@caritas-dev.intel.com> <20070624070601.GB24941@kroah.com>
In-Reply-To: <20070624070601.GB24941@kroah.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> I'm still not convinced that we need to add this kind of complexity to
> the driver core, instead of just letting the individual driver
> subsystems do this, if they want to do it.
> 
> Especially as no subsystem wants to do this today :)

Yes, it should first be shown (with subsystem conversions and runtime
tests with, say, at least two different bus architectures) that features
like this really are appropriately implemented as a driver core abstraction.

I would lend a hand to put this to test, but I won't do this anymore
with the old ieee1394 subsystem, and work on the new firewire subsystem
will be focused on stabilization and feature completion in the short to
mid term.
-- 
Stefan Richter
-=====-=-=== -==- ==---
http://arcgraph.de/sr/
