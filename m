Return-Path: <linux-kernel-owner+w=401wt.eu-S1760242AbYGBV5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760242AbYGBV5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 17:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbYGBV5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 17:57:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51182 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbYGBV5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 17:57:04 -0400
Message-ID: <486BF9AC.6070704@firstfloor.org>
Date: Wed, 02 Jul 2008 23:57:00 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Nathan Lynch <ntl@pobox.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Removing sysdevs?
References: <18539.8141.683072.967851@cargo.ozlabs.ibm.com> <486B9B3A.4060709@firstfloor.org> <20080702185145.GB20938@kroah.com> <200807022341.44965.rjw@sisk.pl> <20080702214853.GA10451@kroah.com>
In-Reply-To: <20080702214853.GA10451@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The plan is:
> 	- remaining driver core cleanups to allow for multiple drivers
> 	  to be bound to individual devices
> 	- add multiple binding support to the core
> 	- migrate existing sysdevs to struct device, now that multiple
> 	  binding is allowed
> 	- delete sysdev structure
> 	- profit!

I hope the sysdev semantics of running with interrupts etc. will be kept?

> 
> It's that first step that is taking a while, the last big changes will
> be going into 2.6.27 to help accomplish this, after that merge happens
> for 2.6.27-rc1 I'll be working on the remaining steps.

So what's up with the sysdev attribute passing changes i posted? Are you
going to put them in or will the conversion happen so soon that they're
not worth it?

I eventually need the passed attribute for the dynamic bank patches.

-Andi
