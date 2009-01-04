Return-Path: <linux-kernel-owner+w=401wt.eu-S1752801AbZADJtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbZADJtR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 04:49:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbZADJtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 04:49:03 -0500
Received: from gate.crashing.org ([63.228.1.57]:35056 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbZADJtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 04:49:01 -0500
Subject: Re: [PATCH] printk: Let %pR handle NULL pointers
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.58.0901031827380.25853@shell2.speakeasy.net>
References: <1230979341-23029-1-git-send-email-xyzzy@speakeasy.org>
	 <alpine.LFD.2.00.0901030905140.3179@localhost.localdomain>
	 <1231019614.15389.104.camel@pasglop>
	 <Pine.LNX.4.58.0901031827380.25853@shell2.speakeasy.net>
Content-Type: text/plain
Date: Sun, 04 Jan 2009 20:48:13 +1100
Message-Id: <1231062493.15389.105.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I thought of doing that too, but then all the various %pX formats would all
> have to print the same for NULL pointers.  For instance a resource prints
> out like "[0x1000-0x100f]", so I chose "[NULL]" for printing a null
> resource pointer.  Maybe "[]" or "[-]" would be better?  A null MAC address
> could be ":::::" or "x:x:x:x:x:x".  "N.U.L.L" or "x.x.x.x" for a null IP4
> address.  And so on.  So the printout looks nicer when a NULL pointer isn't
> a bug.

And how often is that ?

Seriously... 

Ben.


