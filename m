Return-Path: <linux-kernel-owner+w=401wt.eu-S933695AbXBYK1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933695AbXBYK1V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 05:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933696AbXBYK1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 05:27:20 -0500
Received: from quechua.inka.de ([193.197.184.2]:55837 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933695AbXBYK1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 05:27:20 -0500
To: linux-kernel@vger.kernel.org
Subject: Re: ipv4 and ipv6 stacks for new link layers?
References: <200702231149.l1NBnlZD029626@moth.iki.fi> <E1HKzK9-0001aX-TT@bigred.inka.de> <200702241645.l1OGj3GV023299@moth.iki.fi>
Organization: private Linux site, southern Germany
From: Olaf Titz <olaf@bigred.inka.de>
Date: Sun, 25 Feb 2007 11:27:13 +0100
Message-ID: <E1HLGb3-000102-Dh@bigred.inka.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> In current architecture, you have to patch kernel IPv6 and IPv4
> protocols when you add new link layer that they don't recognize.

Which is right, because the IP layer is the place which knows how to
map IP addresses to link layer addresses.

IP must know its link layer. E.g. it needs a way to decide if the link
layer is multicast capable at all.

> I think that is worse than allow a new driver to provide a simple
> service function which maps IPv4/6 multicast address into link layer
> address, when asked.

"Link layer address" is not a generic concept at all, even though too
much code assumes everything is Ethernet.

Olaf
