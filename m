Return-Path: <linux-kernel-owner+w=401wt.eu-S965580AbXCBUcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965580AbXCBUcG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 15:32:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965579AbXCBUcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 15:32:06 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54371
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965580AbXCBUcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 15:32:04 -0500
Date: Fri, 02 Mar 2007 12:32:02 -0800 (PST)
Message-Id: <20070302.123202.11628478.davem@davemloft.net>
To: johnstul@us.ibm.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       andreas.friedrich@fujitsu-siemens.com, tglx@linutronix.de,
       dwalker@mvista.com
Subject: Re: [PATCH -mm] clocksource init adjustments (fix bug #7426)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1172865491.5449.13.camel@localhost.localdomain>
References: <1172189582.5422.26.camel@localhost.localdomain>
	<20070302021827.7edc1a23.akpm@linux-foundation.org>
	<1172865491.5449.13.camel@localhost.localdomain>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: john stultz <johnstul@us.ibm.com>
Date: Fri, 02 Mar 2007 11:58:11 -0800

> Oh! Sorry! Yea, looking at it more the ioremap isn't actually necessary,
> as we can use hpet_readl() instead of re-calculating the hpet base
> address pointer.
> 
> I'll fix this up (and find an HPET enabled x86_64 box to test it on) and
> get a patch to you shortly.

Not to pressure you John but I'd really like to see this go
in soon, it does fix real bugs such as the Radeon FB issue
I pointed out the other week.

Once this is in I can integrate sparc64 clocksource/clockevent
support.

Thanks!
