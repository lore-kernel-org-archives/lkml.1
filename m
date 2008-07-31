Return-Path: <linux-kernel-owner+w=401wt.eu-S1756653AbYGaK0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbYGaK0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 06:26:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYGaKZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 06:25:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56596
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750887AbYGaKZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 06:25:54 -0400
Date: Thu, 31 Jul 2008 03:25:53 -0700 (PDT)
Message-Id: <20080731.032553.67275433.davem@davemloft.net>
To: dwmw2@infradead.org
Cc: torvalds@linux-foundation.org, thomas.petazzoni@free-electrons.com,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       michael@free-electrons.com
Subject: Re: [patch 0/4] [resend] Add configuration options to disable
 features not needed on embedded devices
From: David Miller <davem@davemloft.net>
In-Reply-To: <1217499316.3454.118.camel@pmac.infradead.org>
References: <1217498355.3454.103.camel@pmac.infradead.org>
	<20080731.030205.153067850.davem@davemloft.net>
	<1217499316.3454.118.camel@pmac.infradead.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>
Date: Thu, 31 Jul 2008 11:15:16 +0100

> While I agree with Andrew's observation, I'd also respectfully submit
> that your argument is more fundamentally bogus than that. TCP and UDP
> are _not_ universally available. They go away if you set CONFIG_INET=n.

Like I said, people can locally patch their systems if they really
want to rip out fundamental things like multicast support.

Some folks might find it instructive to do a google code search
or similar on the multicast socket options this things dikes out
of the tree.

Even simple things like NTP will spew failures with this CONFIG_IGMP
thing turned off.  And that's just the tip of the iceberg.
