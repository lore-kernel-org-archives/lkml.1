Return-Path: <linux-kernel-owner+w=401wt.eu-S1161130AbXBAAdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161130AbXBAAdy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 19:33:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161124AbXBAAdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 19:33:53 -0500
Received: from www.osadl.org ([213.239.205.134]:34786 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161122AbXBAAdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 19:33:53 -0500
Subject: Re: [PATCH 14/23] clocksource: increase initcall priority
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Daniel Walker <dwalker@mvista.com>
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1170288912.9781.177.camel@imap.mvista.com>
References: <20070131194311.4B8381FD833@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	 <1170283629.9781.163.camel@imap.mvista.com>
	 <1170285826.29240.227.camel@localhost.localdomain>
	 <1170288912.9781.177.camel@imap.mvista.com>
Content-Type: text/plain
Date: Thu, 01 Feb 2007 01:34:43 +0100
Message-Id: <1170290084.29240.246.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-31 at 16:15 -0800, Daniel Walker wrote:
> > clocksource_initcall is simply superfluid. 
>
> My position has always been that clocksources should be registered as
> early as possible .. The fs_initcall() usage is a compromise stemming
> from early resistance that John, and you gave to moving the clocks up in
> the initcall sequence.

No. I never objected against the registering of clocks at any given
time. Why would I have otherwise accepted ARM patches, which register
their clocksources in the early timer init ?

The only concern I had and still have is when we decide to use something
else than the "safe" heaven of jiffies.

	tglx


