Return-Path: <linux-kernel-owner+w=401wt.eu-S1753367AbZAFGHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbZAFGHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 01:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbZAFGHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 01:07:41 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43194
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751167AbZAFGHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 01:07:40 -0500
Date: Mon, 05 Jan 2009 22:07:42 -0800 (PST)
Message-Id: <20090105.220742.176919041.davem@davemloft.net>
To: sam@ravnborg.org
Cc: jaswinderlinux@gmail.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [GIT]: Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090106055144.GA11695@uranus.ravnborg.org>
References: <20090105.204934.65827705.davem@davemloft.net>
	<3f9a31f40901052114t68cac881md439bf24b602f269@mail.gmail.com>
	<20090106055144.GA11695@uranus.ravnborg.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Tue, 6 Jan 2009 06:51:44 +0100

> We should avoid a central file and push this information
> out to the Kconfig files that are at the driver site.
> 
> Then we can postprocess autoconf.h to get the filenames etc.

I'll take this opportunity to once again promote my idea wherein build
information (and perhaps other bits like firmware info) for a driver
is encoded into the source of the driver itself, and the build system
just extracts that stuff into Makefiles and whatnot at build time. :-)

Couldn't resist.
