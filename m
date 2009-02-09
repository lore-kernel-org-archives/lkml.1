Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbZBIVn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbZBIVn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 16:43:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbZBIVnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 16:43:18 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:15112 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751837AbZBIVnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 16:43:16 -0500
X-Trace: 146323127/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.44.176.250/None/adrian@newgolddream.dyndns.info
X-SBRS: None
X-RemoteIP: 80.44.176.250
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-MUA: Evolution 2.24.3 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAD4ykElQLLD6/2dsb2JhbACBbs9khBoG
X-IronPort-AV: E=Sophos;i="4.37,406,1231113600"; 
   d="scan'208";a="146323127"
Subject: Re: [PATCH] sh: maple: add support for Visual Memory Card devices,
 and make consequential changes to maple input drivers - 2/3 - v5
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Paul Mundt <lethal@linux-sh.org>, Greg KH <greg@kroah.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       dwmw2 <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       MTD <linux-mtd@lists.infradead.org>,
       linux-sh <linux-sh@vger.kernel.org>,
       linux-input <linux-input@vger.kernel.org>
In-Reply-To: <200902091433.57126.vapier@gentoo.org>
References: <1234122069.6736.8.camel@localhost.localdomain>
	 <20090209065632.GA21980@linux-sh.org>
	 <1234207053.6756.11.camel@localhost.localdomain>
	 <200902091433.57126.vapier@gentoo.org>
Content-Type: text/plain
Date: Mon, 09 Feb 2009 21:41:56 +0000
Message-Id: <1234215716.6756.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-09 at 14:33 -0500, Mike Frysinger wrote:

> 
> then you'd end up with 4 clearly marked files (assuming your log message for 
> each change is clear).  in the summary, you should then make statements like:
> Patch 1 (... subject ...) in this series can be applied by itself for the bus 
> driver.  Then patch 2 (... subject ...) and 3 (... subject ...) can be applied 
> as they need the bus changes.
> -mike


Fair enough.

I ought to resubmit patches anyway because previous code has a memory
leak/race which I've now fixed with a couple of extra lines.

But the basic point here is that changing the bus code is necessary to
get the VMU driver (or *any* VMU driver) to work, but changing the bus
driver also breaks the two existing drivers in mainline that use the
bus. The breakage in terms of lines to be fixed is small, but it still
needs to be done 'all at once'.

