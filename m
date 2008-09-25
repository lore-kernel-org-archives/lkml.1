Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbYIYC3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbYIYC3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 22:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbYIYC3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 22:29:25 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35580 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbYIYC3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 22:29:25 -0400
Message-ID: <48DAF75D.4050908@garzik.org>
Date: Wed, 24 Sep 2008 22:28:45 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Dave Airlie <airlied@gmail.com>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, jeffrey.t.kirsher@intel.com,
       david.vrabel@csr.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, chrisl@vmware.com,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org,
       jesse.brandeburg@gmail.com
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
References: <20080923.150722.141587696.davem@davemloft.net>  <9929d2390809231512w160d221axa2923a6b293a041@mail.gmail.com>  <alpine.LNX.1.10.0809240014390.4671@pegasus.suse.cz>  <20080923.211215.193696086.davem@davemloft.net>  <alpine.LNX.1.10.0809250110070.4671@pegasus.suse.cz> <21d7e9970809241722w7c3bb6a5w1af5801b7380169d@mail.gmail.com> <alpine.LNX.1.10.0809250310190.4671@pegasus.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0809250310190.4671@pegasus.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Thu, 25 Sep 2008, Dave Airlie wrote:
> 
>> Well I'm out of the race, my attempts to re-write my eeprom using an 
>> eeprom from an equivalent laptop have totally failed and my BIOS won't 
>> boot anymore - so my laptop is == a brick.
> 
> Uh oh. Shouldn't we put something like the patch below in Linus' tree 
> unless we get this sorted out? Otherwise more and more people who use -rc 
> kernels will run into this, and will get their hardware [hopefully 
> temporarily, but not all users are able to re-flash their network card 
> EEPROMs, right] bricked.
> 
> I know that it is quite aggressive and is going to disable wired 
> networking on a lot of systems that have been functioning properly, 
> therefore RFC ...
> 
> 
> 
> From: Jiri Kosina <jkosina@suse.cz>
> Subject: [PATCH] [RFC] E1000E: temporarily disable e1000e driver
> 
> E1000E: temporarily disable e1000e driver

That seems a bit drastic, particularly when the debugging was beginning 
to point to another culprit.

We have equal case at this point to disable r8169 and i915_drm, no?

	Jeff




