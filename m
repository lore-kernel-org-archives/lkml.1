Return-Path: <linux-kernel-owner+w=401wt.eu-S1755123AbXJ2McI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbXJ2McI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 08:32:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343AbXJ2Mbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 08:31:55 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48622 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbXJ2Mbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 08:31:55 -0400
Message-ID: <4725D2A5.1050908@linux.vnet.ibm.com>
Date: Mon, 29 Oct 2007 18:01:33 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: Christian Borntraeger <borntraeger@de.ibm.com>,
       Chuck Ebbert <cebbert@redhat.com>, Greg KH <greg@kroah.com>,
       stable@kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [stable] 2.6.23 regression: top displaying 9999% CPU usage
References: <200710122231.50739.elendil@planet.nl> <200710161234.35529.borntraeger@de.ibm.com> <4714B5BF.1090001@linux.vnet.ibm.com> <200710291305.52992.elendil@planet.nl>
In-Reply-To: <200710291305.52992.elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> Hello Balbir,

[snip]

> Any progress on this issue? I noticed that it's still there in current git.
> 

I have been looking elsewhere, sorry, I'll look into this issue tonight

> If a better implementation is not expected any time soon, how about an ACK 
> on the reversion patch Christian proposed in
> http://lkml.org/lkml/2007/10/16/76
> so we can at least get rid of the regression?
> 

We'll I initially thought of it and then I remembered that the
regression occurs only when the accounting itself is inaccurate.
I am tempted to ack the removal, but I would like to get input
from others. Meanwhile, I'll try and see if I can fix the problem

> Thanks,
> Frans Pop


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
