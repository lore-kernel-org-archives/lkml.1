Return-Path: <linux-kernel-owner+w=401wt.eu-S1752273AbXBXQ1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbXBXQ1f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 11:27:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932841AbXBXQ1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 11:27:35 -0500
Received: from quechua.inka.de ([193.197.184.2]:43068 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbXBXQ1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 11:27:34 -0500
X-Greylist: delayed 1610 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Feb 2007 11:27:34 EST
To: linux-kernel@vger.kernel.org
Subject: Re: ipv4 and ipv6 stacks for new link layers?
References: <200702231149.l1NBnlZD029626@moth.iki.fi>
Organization: private Linux site, southern Germany
From: Olaf Titz <olaf@bigred.inka.de>
Date: Sat, 24 Feb 2007 17:00:37 +0100
Message-ID: <E1HKzK9-0001aX-TT@bigred.inka.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This is a pity, because it would be so easy to make the both stacks
> totally independent of the actual link layers. It only needs one (or
> two) new function pointer in net_device. This function should do the
> conversion from IPv4/IPv6 address into corresponding hardware
> multicast/broadcast address.

You mean, the link layer drivers should know of IP addressing modes?
Sounds like a layering violation to me. The mapping from IP to MAC
address is (for a good reason) part of the IP specs, not of the
Ethernet, Token Ring etc. specs, so the right place to implement it is
not the network drivers.

Olaf
