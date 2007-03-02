Return-Path: <linux-kernel-owner+w=401wt.eu-S1422688AbXCBB1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422688AbXCBB1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 20:27:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422696AbXCBB1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 20:27:14 -0500
Received: from mail1.skjellin.no ([80.239.42.67]:59362 "EHLO mx1.skjellin.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422688AbXCBB1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 20:27:06 -0500
X-Greylist: delayed 1909 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Mar 2007 20:27:06 EST
Message-ID: <45E775DC.9080405@tomt.net>
Date: Fri, 02 Mar 2007 01:54:52 +0100
From: Andre Tomt <andre@tomt.net>
User-Agent: Thunderbird 2.0b2 (Windows/20070116)
MIME-Version: 1.0
To: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
CC: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH, RFT, v2] sata_mv: convert to new EH
References: <20070225233454.GA31282@havoc.gtf.org>
In-Reply-To: <20070225233454.GA31282@havoc.gtf.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Just got sata_mv working under the new EH, on my 6041.
>
> It probes and talks to disks just fine (chip doesn't support ATAPI),
> and hotplug actually has a chance of working.
>
> The 'mv-eh' branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git mv-eh
>   

It's great to see this driver getting some more love. On a 6041 I'm 
seeing very bad behaviour when encountering errors using the 2.6.19 
driver. If a disk gets the fits, the port dies and 500000 interrupts/s 
gets fired until the server gets rebooted. Good thing it only pegs one 
of four available cpu cores.. I hope the new EH is more robust in this 
regard ;-)

Ramblings aside; I see there is a mv-ncq head in libata-dev.git, do you 
have it working? Is there a timeframe for NCQ support?
