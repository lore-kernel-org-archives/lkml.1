Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbXGHAld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbXGHAld (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 20:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbXGHAlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 20:41:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:32995 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbXGHAlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 20:41:24 -0400
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Alan Stern <stern@rowland.harvard.edu>, Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <20070707114917.GC2789@elf.ucw.cz>
References: <Pine.LNX.4.44L0.0707061034540.3737-100000@iolanthe.rowland.org>
	 <1183779845.3388.206.camel@localhost.localdomain>
	 <20070707114917.GC2789@elf.ucw.cz>
Content-Type: text/plain
Date: Sun, 08 Jul 2007 10:40:46 +1000
Message-Id: <1183855247.3388.231.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-07 at 13:49 +0200, Pavel Machek wrote:

> And anyway I believe that current issue (fuse deadlocks with s2ram)
> should be present on powerbooks, too... it is just way harder to
> trigger. All that is neccessary is fused (or one of its helpers) to
> get frozen by accessing suspended device.

I don't see any fuse specific issue without a freezer, but I see generic
issues such as kmalloc blocking in a driver with a mutex held etc... but
I've talked about these already. They have nothing to do with the
freezer though.

Ben.


