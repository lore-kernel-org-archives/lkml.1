Return-Path: <linux-kernel-owner+w=401wt.eu-S2992570AbXCWUu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992570AbXCWUu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 16:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992571AbXCWUu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 16:50:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41073 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992570AbXCWUu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 16:50:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: [3/5] 2.6.21-rc4: known regressions (v2)
Date: Fri, 23 Mar 2007 21:53:51 +0100
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, pavel@suse.cz,
       linux-pm@lists.osdl.org, Maxim Levitsky <maximlevitsky@gmail.com>,
       Mike Harris <atarimike@wavecable.com>, Marcus Better <marcus@better.se>,
       Jeff Chua <jeff.chua.linux@gmail.com>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <20070323185022.GQ752@stusta.de>
In-Reply-To: <20070323185022.GQ752@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703232153.53239.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 23 March 2007 19:50, Adrian Bunk wrote:
> This email lists some known regressions in Linus' tree compared to 2.6.20.
> 
> If you find your name in the Cc header, you are either submitter of one
> of the bugs, maintainer of an affectected subsystem or driver, a patch
> of you caused a breakage or I'm considering you in any other way
> possibly involved with one or more of these issues.
> 
> Due to the huge amount of recipients, please trim the Cc when answering.
> 
[--snip--]
> Subject    : suspend to disk hangs
> References : http://lkml.org/lkml/2007/3/16/126
> Submitter  : Maxim Levitsky <maximlevitsky@gmail.com>
> Caused-By  : Rafael J. Wysocki <rjw@sisk.pl>
>              commit e3c7db621bed4afb8e231cb005057f2feb5db557
>              commit ed746e3b18f4df18afa3763155972c5835f284c5
>              commit 259130526c267550bc365d3015917d90667732f1
> Status     : unknown

The problem has been identified as the known issue related to the XFS freezable
workqueues.  There is a patch available (http://lkml.org/lkml/2007/3/21/328),
that has been merged.

Still, there is a problem with the microcode update driver that's being worked
on.

The reporters of the resume problems who use the microcode driver, please
check if the problems go away if you unload the driver before the suspend.

Greetings,
Rafael
