Return-Path: <linux-kernel-owner+w=401wt.eu-S932685AbZHRCA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685AbZHRCA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 22:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbZHRCAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 22:00:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:28289 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbZHRCAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 22:00:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,399,1246863600"; 
   d="scan'208";a="717704493"
Subject: Re: [RFC][PATCH 0/7] PM: Asynchronous suspend and resume (updated)
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>, Greg KH <gregkh@suse.de>
In-Reply-To: <200908170215.21173.rjw@sisk.pl>
References: <200908122218.13975.rjw@sisk.pl>
	 <200908170215.21173.rjw@sisk.pl>
Content-Type: text/plain
Date: Tue, 18 Aug 2009 09:59:22 +0800
Message-Id: <1250560762.5351.44.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hmm,
what are these patches based on?
I tried an 2.6.31-rc6 kernel together with your run-time PM patch (rev.
17) but still failed.

thanks,
rui

On Mon, 2009-08-17 at 08:15 +0800, Rafael J. Wysocki wrote:
> On Wednesday 12 August 2009, Rafael J. Wysocki wrote:
> > Hi,
> > 
> > The following patches introduce a mechanism allowing us to execute device
> > drivers' suspend and resume callbacks asynchronously during system sleep
> > transitions, such as suspend to RAM.  The idea is explained in the [1/1] patch
> > message.
> 
> Changes:
> 
> * Added [1/7] that fixes kerneldoc comments in drivers/base/power/main.c
>   (this is a 2.6.32 candidate).
> 
> * Added [2/7] adding a framework for representing PM link (idea described
>   in the patch message).
> 
> * [3/7] is the async resume patch (idea described in the patch message).
> 
> * [4/7] is the async suspend patch.
> 
> * [5/7] - [7/7] set async_suspend for devices in a few selected subsystems.
> 
> The patches have been tested on HP nx6325.
> 
> Comments welcome.
> 
> Thanks,
> Rafael
> 

