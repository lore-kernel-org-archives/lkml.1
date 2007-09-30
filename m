Return-Path: <linux-kernel-owner+w=401wt.eu-S1752854AbXI3UGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbXI3UGS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 16:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbXI3UGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 16:06:08 -0400
Received: from ns1.suse.de ([195.135.220.2]:56310 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbXI3UGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 16:06:06 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
Date: Sun, 30 Sep 2007 22:05:57 +0200
User-Agent: KMail/1.9.6
Cc: Joshua Brindle <method@manicmethod.com>,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       torvalds@linux-foundation.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       Paul Moore <paul.moore@hp.com>
References: <46FEEBD4.5050401@schaufler-ca.com> <200709301939.57542.ak@suse.de> <20070930190742.GB9358@thunk.org>
In-Reply-To: <20070930190742.GB9358@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709302205.58017.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Yes, normally the network is outside the Trusted Computing Base (TCB),

Normally as in the 99.99999% case.

> but a cluster of Linux machines in a rack is roughly the same size of
> a huge Unix server tens year ago --- and it's not like Ethernet is any
> more secure than the PCI bus.  

PCI busses normally don't have routers to networks outside the box connected
to them. 

> So don't be so quick to dismiss something like 
> CIPSO out of hand, just because it doesn't use IPSEC.

With your argumentation we could also just disable all security
in these situations (as in null LSM to save some overhead); after all these 
systems are protected by armed guards.  If someone gets past the guards
they could connect their laptop to the network and fake all the "secured"
packets. If you assume that won't happen why do you need computer security at all?

Anyways; if someone wants to cripple their security for some
performance this way they can surely do this; but i don't think we should 
offer it as a default configuration option (just as we don't have a 
CONFIG_NULL_LSM even though there are undoubtedly systems that don't
care about permission checking[1]) 

-Andi

[1] I bet I gave the linux-tiny crowd an idea now ;-)

