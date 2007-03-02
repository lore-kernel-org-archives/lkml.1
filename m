Return-Path: <linux-kernel-owner+w=401wt.eu-S1422715AbXCBIq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422715AbXCBIq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 03:46:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422678AbXCBIqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 03:46:25 -0500
Received: from mta2.cl.cam.ac.uk ([128.232.0.14]:53895 "EHLO mta2.cl.cam.ac.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422681AbXCBIqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 03:46:25 -0500
User-Agent: Microsoft-Entourage/11.3.3.061214
Date: Fri, 02 Mar 2007 08:46:04 +0000
Subject: Re: [RFC] Arp announce (for Xen)
From: Keir Fraser <Keir.Fraser@cl.cam.ac.uk>
To: Stephen Hemminger <shemminger@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
CC: <xen-devel@lists.xensource.com>, Jeff Garzik <jeff@garzik.org>,
       Ian Pratt <ian.pratt@xensource.com>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Andi Kleen <ak@muc.de>, <Zachary@smtp.osdl.org>,
       <virtualization@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>
Message-ID: <C20D94CC.3237%Keir.Fraser@cl.cam.ac.uk>
Thread-Topic: [RFC] Arp announce (for Xen)
Thread-Index: AcdcpzYVdIiLbsiaEduMdgAWy6hiGQ==
In-Reply-To: <20070301173030.754514ec@freekitty>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/3/07 01:30, "Stephen Hemminger" <shemminger@linux-foundation.org>
wrote:

> What about implementing the unused arp_announce flag on the inetdevice?
> Something like the following.  Totally untested...
> 
> Looks like it either was there (and got removed) or was planned but
> never implemented.

This would be acceptable. It only needs a simple script to poke the correct
value, and that could be easily integrated into vendor scripts. The general
idea of being able to have a callback to userspace is okay but we'd like
something lighter weight for live migration, which is typically done only
within the scope of a single layer-2 network and hence all that is really
required is the gratuitous ARP to kick the switch hardware.

 -- Keir


