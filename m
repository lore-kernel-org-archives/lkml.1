Return-Path: <linux-kernel-owner+w=401wt.eu-S1757863AbYBDXJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863AbYBDXJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 18:09:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755248AbYBDXJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 18:09:49 -0500
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:43735 "EHLO
	mk-filter-3-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752947AbYBDXJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 18:09:48 -0500
X-Trace: 679012510/mk-filter-3.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.66
X-SBRS: None
X-RemoteIP: 81.1.89.66
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAPsnp0dRAVlC/2dsb2JhbACBWKsl
Subject: Re: [PATCH] SH/Dreamcast - fix regressions, whitespace and memory
	leaks in Maple Bus driver
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Greg KH <greg@kroah.com>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-sh <linux-sh@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1202164657.7046.5.camel@localhost.localdomain>
References: <1202068847.6262.7.camel@localhost.localdomain>
	 <20080204052900.GB7585@kroah.com>
	 <1202113675.6489.6.camel@localhost.localdomain>
	 <20080204161437.GA20739@kroah.com>
	 <1202164657.7046.5.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 04 Feb 2008 23:09:20 +0000
Message-Id: <1202166560.7046.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-04 at 22:37 +0000, Adrian McMenamin wrote:

> 
> The hardware is very flaky. If I add in delays to the bus start, it will
> detect the devices, but it's not brilliant. Registering an empty device
> got round that problem, at the price of testing for the earlier
> registration.
> 


I have found if I push it (and drivers) further down the initcall
hierarchy that problem is less significant and the hardware seems to be
properly detected.

I'll look to post a clean up series of patches in the next few days.

