Return-Path: <linux-kernel-owner+w=401wt.eu-S1761339AbXLADsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761339AbXLADsZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 22:48:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758893AbXLADsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 22:48:06 -0500
Received: from rtr.ca ([76.10.145.34]:4175 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758755AbXLADsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 22:48:03 -0500
Message-ID: <4750D971.7000603@rtr.ca>
Date: Fri, 30 Nov 2007 22:48:01 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, abelay@novell.com,
       lenb@kernel.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: + restore-missing-sysfs-max_cstate-attr.patch added to -mm tree
References: <200711302153.lAULrZ7n026255@imap1.linux-foundation.org>	<924EFEDD5F540B4284297C4DC59F3DEE2FAE6A@orsmsx423.amr.corp.intel.com>	<20071130142058.816d1693.akpm@linux-foundation.org>	<924EFEDD5F540B4284297C4DC59F3DEE2FAEAF@orsmsx423.amr.corp.intel.com>	<4750CC78.9070105@rtr.ca>	<20071130190227.1976e682@laptopd505.fenrus.org>	<4750D180.6080001@rtr.ca> <20071130191816.3e744205@laptopd505.fenrus.org> <4750D585.1030200@rtr.ca> <4750D899.4020905@rtr.ca>
In-Reply-To: <4750D899.4020905@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
>..
> And I just figured out the powertop:  it needed the kernel timers
> patch from the powertop site that was originally for 2.6.21..
> Any chance of somebody actually pushing that patch upstream some year ??
> Patch reproduced here for interest's sake only.
> Hey, look who's on the Signed-off list for it, *Arjan* !
...

Mmm.. hey, I was using this patch on 2.6.23 as well..

I wonder if perhaps this is the culprit for the mysterious 1-second delays
that sometimes slow down resume (from RAM) on my machine from 2 seconds
(normal) to 20 seconds (slow) ?   
