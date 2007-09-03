Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbXICTXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbXICTXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 15:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbXICTW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 15:22:58 -0400
Received: from jabberwock.ucw.cz ([89.250.246.4]:56518 "EHLO jabberwock.ucw.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087AbXICTW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 15:22:58 -0400
X-Greylist: delayed 1286 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Sep 2007 15:22:58 EDT
Date: Mon, 3 Sep 2007 21:01:24 +0200
From: Martin Mares <mj@ucw.cz>
To: dean gaudet <dean@arctic.org>
Cc: Robert Richter <robert.richter@amd.com>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 5/5] x86: Set PCI config space size to extended for AMD Barcelona
Message-ID: <mj+md-20070903.190044.18705.albireo@ucw.cz>
References: <20070903081736.288288000@amd.com> <20070903081736.805623000@amd.com> <Pine.LNX.4.64.0709030930150.3502@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709030930150.3502@twinlark.arctic.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> it's so very unfortunate the PCI standard has no feature bit to indicate 
> the presence of ECS.
> 
> FWIW in my testing on a range of machines spanning 7 or 8 years i could 
> read config space reg 256... and get 0xffffffff when the device didn't 
> support ECS, and get valid data when the device did support ECS... granted 
> there may be some system out there which behaves really badly when you do 
> this.
> 
> perhaps someone could write a userspace program and test that concept on a 
> far wider range of machines.

If you want to experiment with this in user space, it's easy to write
a couple of access functions for the libpci in pciutils. (Patches welcome,
as usually :) )

				Have a nice fortnight
-- 
Martin `MJ' Mares                          <mj@ucw.cz>   http://mj.ucw.cz/
Faculty of Math and Physics, Charles University, Prague, Czech Rep., Earth
God is real, unless declared integer.
