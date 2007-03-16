Return-Path: <linux-kernel-owner+w=401wt.eu-S2992437AbXCPWlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992437AbXCPWlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 18:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992440AbXCPWlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 18:41:32 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:47012 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992437AbXCPWlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 18:41:31 -0400
Date: Fri, 16 Mar 2007 15:39:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.21-rc4
Message-Id: <20070316153957.232cf648.randy.dunlap@oracle.com>
In-Reply-To: <20070316141121.82ba7cb8.randy.dunlap@oracle.com>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	<20070316141121.82ba7cb8.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2007 14:11:21 -0700 Randy Dunlap wrote:

> On Fri, 16 Mar 2007 09:33:54 -0700 (PDT) Linus Torvalds wrote:
> 
> > 
> > I pushed out the -git trees yesterday, but then got distracted, so the 
> > patches and tar-balls and the announcement got delayed until this morning. 
> > Oops. I'm a scatter-brain.
> 
> allmodconfig on i386:
> 
> WARNING: "default_idle" [arch/i386/kernel/apm.ko] undefined!
> WARNING: "machine_real_restart" [arch/i386/kernel/apm.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2

Please ignore.

I think that this was the result of doing 'make allyesconfig && make all'
followed by 'make allmodconfig && make all' without doing a 'make clean'
between them.

---
~Randy
