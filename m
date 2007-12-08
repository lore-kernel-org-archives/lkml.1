Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbXLHKpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbXLHKpA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 05:45:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbXLHKou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 05:44:50 -0500
Received: from [212.12.190.148] ([212.12.190.148]:37465 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750991AbXLHKot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 05:44:49 -0500
From: Al Boldi <a1426z@gawab.com>
To: Valdis.Kletnieks@vt.edu
Subject: Re: git guidance
Date: Sat, 8 Dec 2007 13:41:54 +0300
User-Agent: KMail/1.5
Cc: Jakub Narebski <jnareb@gmail.com>, Andreas Ericsson <ae@op5.se>,
       Johannes Schindelin <Johannes.Schindelin@gmx.de>,
       Phillip Susi <psusi@cfl.rr.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jing Xue <jingxue@digizenstudio.com>, linux-kernel@vger.kernel.org,
       git@vger.kernel.org
References: <20071129105220.v40i22q4gw4cgoso@intranet.digizenstudio.com> <200712080756.21980.a1426z@gawab.com> <7135.1197090987@turing-police.cc.vt.edu>
In-Reply-To: <7135.1197090987@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200712081341.54589.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Sat, 08 Dec 2007 07:56:21 +0300, Al Boldi said:
> > It probably goes without saying, that gitfs should have some basic
> > configuration file to setup its transparent behaviour
>
> But then it's not *truly* transparent, is it?

Don't mistake transparency with some form of auto-heuristic.  Transparency 
only means that it inserts functionality without impeding your normal 
workflow.

> And that leaves another question - if you make a config file that excludes
> all the .o files - then what's backing the .o files?  Those data blocks
> need to be *someplace*.  Maybe you can do something ugly like use unionfs
> to combine your gitfs with something else to store the other files...

Or any number of other possible implementation scenarios...

> But at that point, you're probably better off just creating a properly
> designed versioning filesystem.

But gitfs is not about designing a versioning filesystem, it's about 
designing a transparent interface into git to handle an SCM use-case.


Thanks!

--
Al

