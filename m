Return-Path: <linux-kernel-owner+w=401wt.eu-S1750934AbXBXQpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750934AbXBXQpJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 11:45:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbXBXQpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 11:45:09 -0500
Received: from burp.tkv.asdf.org ([212.16.99.49]:42211 "EHLO moth.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbXBXQpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 11:45:08 -0500
Date: Sat, 24 Feb 2007 18:45:03 +0200
Message-Id: <200702241645.l1OGj3GV023299@moth.iki.fi>
From: Markku Savela <msa@moth.iki.fi>
To: olaf@bigred.inka.de
CC: linux-kernel@vger.kernel.org
In-reply-to: <E1HKzK9-0001aX-TT@bigred.inka.de> (message from Olaf Titz on
	Sat, 24 Feb 2007 17:00:37 +0100)
Subject: Re: ipv4 and ipv6 stacks for new link layers?
References: <200702231149.l1NBnlZD029626@moth.iki.fi> <E1HKzK9-0001aX-TT@bigred.inka.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > This is a pity, because it would be so easy to make the both stacks
> > totally independent of the actual link layers. It only needs one (or
> > two) new function pointer in net_device. This function should do the
> > conversion from IPv4/IPv6 address into corresponding hardware
> > multicast/broadcast address.
> 
> You mean, the link layer drivers should know of IP addressing modes?
> Sounds like a layering violation to me. The mapping from IP to MAC
> address is (for a good reason) part of the IP specs, not of the
> Ethernet, Token Ring etc. specs, so the right place to implement it is
> not the network drivers.

I disagree.

In current architecture, you have to patch kernel IPv6 and IPv4
protocols when you add new link layer that they don't recognize.

I think that is worse than allow a new driver to provide a simple
service function which maps IPv4/6 multicast address into link layer
address, when asked.



