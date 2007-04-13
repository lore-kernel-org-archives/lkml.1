Return-Path: <linux-kernel-owner+w=401wt.eu-S1751732AbXDMEXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732AbXDMEXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 00:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751743AbXDMEXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 00:23:16 -0400
Received: from [198.99.130.12] ([198.99.130.12]:52839 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbXDMEXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 00:23:15 -0400
Date: Fri, 13 Apr 2007 00:21:56 -0400
From: Jeff Dike <jdike@addtoit.com>
To: "Christopher S. Aker" <caker@theshore.net>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [Feature Request?] Inline compression of process core dumps
Message-ID: <20070413042156.GA12786@c2.user-mode-linux.org>
References: <461E55C6.1030905@theshore.net> <20070412172845.58bfeff5@the-village.bc.nu> <20070412164251.GC11736@ti88.telemetry-investments.com> <p73ps697agf.fsf@bingen.suse.de> <461EE95A.3090600@theshore.net> <20070412193838.ea98238b.randy.dunlap@oracle.com> <461EF1A1.3070102@theshore.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461EF1A1.3070102@theshore.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 10:57:37PM -0400, Christopher S. Aker wrote:
> The process is a UML instance (skas mode, so at least a kernel, 
> userspace, and io thread), which will generate a single, usable, core 
> file just fine with a non-pipe core_pattern...

Yeah, but can you get a core file without the .pid on the end?  I just
tried, with core_pattern == core and core_uses_pid == 0, and I still
got core.pid.

I can fix this on my end - just have to kill off a bunch of things
before aborting.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
