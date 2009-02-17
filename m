Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbZBQWaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbZBQWaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 17:30:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbZBQWaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 17:30:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41173
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752451AbZBQWaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 17:30:03 -0500
Date: Tue, 17 Feb 2009 14:29:46 -0800 (PST)
Message-Id: <20090217.142946.232071526.davem@davemloft.net>
To: arvidjaar@mail.ru
Cc: rjw@sisk.pl, netdev@vger.kernel.org, bonding-devel@lists.sourceforge.net,
       jamagallon@ono.com, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29 regression? Bonding tied to IPV6 in 29-rc5
From: David Miller <davem@davemloft.net>
In-Reply-To: <200902172001.41804.arvidjaar@mail.ru>
References: <alpine.LFD.2.00.0902131413120.3179@localhost.localdomain>
	<20090217095232.5da06b9f@werewolf.home>
	<200902172001.41804.arvidjaar@mail.ru>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrey Borzenkov <arvidjaar@mail.ru>
Date: Tue, 17 Feb 2009 20:01:38 +0300

> Forward to bonding and netdev
 ...
> If IPv6 is disable in kernel config bonding loads. But I think it is 
> regression, it should be possible to disable IPv6 if not required.

Don't configure ipv6 into your kernel, really.

There is no other way to handle this.  If we want to support
IPV6 layer things in the bonding driver, it is going to
call helper functions in the ipv6 module and therefore must
be able to load it and use functions in it.
