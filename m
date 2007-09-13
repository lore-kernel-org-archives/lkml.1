Return-Path: <linux-kernel-owner+w=401wt.eu-S1754250AbXIMHbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbXIMHbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 03:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbXIMHbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 03:31:14 -0400
Received: from smtp2e.orange.fr ([80.12.242.113]:18518 "EHLO smtp2e.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbXIMHbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 03:31:13 -0400
X-ME-UUID: 20070913073112159.26DC27000082@mwinf2e21.orange.fr
Subject: Re: r8169: can't send magic packet for Wake-On-Lan
From: Xavier Bestel <xavier.bestel@free.fr>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: linux-kernel@vger.kernel.org, shuchen@realtek.com.tw
In-Reply-To: <20070912212025.GA30315@electric-eye.fr.zoreil.com>
References: <1189545366.4403.9.camel@bip.parateam.prv>
	 <20070911213017.GA661@electric-eye.fr.zoreil.com>
	 <1189571526.6098.1.camel@bip.parateam.prv>
	 <20070912212025.GA30315@electric-eye.fr.zoreil.com>
Content-Type: text/plain
Date: Thu, 13 Sep 2007 09:31:06 +0200
Message-Id: <1189668666.1391.65.camel@frg-rhel40-em64t-04>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-12 at 23:20 +0200, Francois Romieu wrote:
> Xavier Bestel <xavier.bestel@free.fr> :
> [...]
> > Err sorry, I mixed up everything ... I'm using *etherwake* to make the
> > WOL magic packet, and ethtool to check the interface options.
> 
> Weird.
> 
> Can you capture the traffic from the receiving (live) r8169 whith
> both senders and specify the kernel version of the sender/receiver ?

Sorry for not following up: the packet arrives correctly to the
receiving host when it's running, the problem is that it doesn't wake
up. As I have changed the switch at the same time (gigabit upgrade)
maybe when the host is powered off the switch doesn't forward the magic
packet ?
I'll dig the old 10/100 hub and try again.

Thanks,
	Xav


