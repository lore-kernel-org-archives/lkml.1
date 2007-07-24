Return-Path: <linux-kernel-owner+w=401wt.eu-S1761782AbXGXORt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761782AbXGXORt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 10:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757070AbXGXORl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 10:17:41 -0400
Received: from smtp.nokia.com ([131.228.20.173]:21439 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756712AbXGXORk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 10:17:40 -0400
Subject: Re: [linux-pm] Power Management framework proposal
From: Igor Stoppa <igor.stoppa@nokia.com>
To: ext Jerome Glisse <j.glisse@gmail.com>
Cc: "david@lang.hm" <david@lang.hm>,
       "ext linux-pm-bounces@lists.linux-foundation.org" 
	<linux-pm-bounces@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
In-Reply-To: <4240b9160707240143u6cdaba64rae93528661f4475c@mail.gmail.com>
References: <Pine.LNX.4.64.0707212339550.6350@asgard.lang.hm>
	 <1185091022.19678.28.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0707220057210.6350@asgard.lang.hm>
	 <1185105911.29238.43.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0707221156210.6350@asgard.lang.hm>
	 <1185187720.26628.23.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0707231033430.3828@asgard.lang.hm>
	 <4240b9160707240143u6cdaba64rae93528661f4475c@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: OSSO
Date: Tue, 24 Jul 2007 17:18:16 +0300
Message-Id: <1185286696.12325.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 24 Jul 2007 14:16:45.0214 (UTC) FILETIME=[43DA2BE0:01C7CDFD]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-24 at 10:43 +0200, ext Jerome Glisse wrote:

> I believe a central place where user can set/change hw state to save
> power or to increase computational power is definitely a goal to pursue.
> But i truly think that the OHM approach is the best one ie using plugins
> so that one can make a plugin specific for each device. The point is that
> i believe there is no way to do an abstract interface for this and trying to
> do so will endup doing ugly code and any interface would fail to encompass
> all possible tweak that might exist for all devices.
> 
> For instance on graphics card you could do the following (maybe more):
> -change GPU clock
> -change memory clock
> -disable part of engine
> -disable unit
> i truly don't think you can make a common interface for all this, more
> over there might be constraint on how you can change things (GPU &
> memory clock might need to follow a given ratio). So you definitely
> need knowledge in the user space program to handle this.

Even simpler case: LCD backlight can come in many flavors, both in terms
of brightness levels and fixed amount of current required to keep it ON.

Trying to abstract such details from the decision-making makes little
sense.
Isolating that into a separate module, instead, brings the best of both
worlds:
-containment of the HW-specific code
-leveraging every possible, no matter how exotic, power saving mode
available.


-- 
Cheers, Igor

Igor Stoppa <igor.stoppa@nokia.com>
(Nokia Multimedia - CP - OSSO / Helsinki, Finland)
