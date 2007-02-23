Return-Path: <linux-kernel-owner+w=401wt.eu-S1752171AbXBWJvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbXBWJvI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 04:51:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbXBWJvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 04:51:08 -0500
Received: from www.osadl.org ([213.239.205.134]:52376 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752171AbXBWJvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 04:51:07 -0500
Subject: sparc generic time / clockevents [ was Re: NO_HZ: timer interrupt
	stuck ]
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, john stultz <johnstul@us.ibm.com>
In-Reply-To: <20070223.012519.48528691.davem@davemloft.net>
References: <1172159501.25076.182.camel@localhost.localdomain>
	 <20070222.092652.55507017.davem@davemloft.net>
	 <1172165959.25076.192.camel@localhost.localdomain>
	 <20070223.012519.48528691.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 23 Feb 2007 10:56:18 +0100
Message-Id: <1172224579.25076.219.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David,

<trimmed CC due to sparcness, added John instaed >

On Fri, 2007-02-23 at 01:25 -0800, David Miller wrote:
> > Yes, all you need is to omit the CLOCK_EVT_FEAT_PERIODIC flag when you
> > register your device.
> 
> Thanks a lot Thomas.
> 
> I noticed while doing this work that the generic clock code is
> incompatible with the time interpolator, since both provide a
> do_{get,set}timeofday() implementation.  Just FYI...

John, can you have a look at this ?

	tglx


