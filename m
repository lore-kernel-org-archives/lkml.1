Return-Path: <linux-kernel-owner+w=401wt.eu-S1759051AbYAGWYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759051AbYAGWYi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 17:24:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668AbYAGWYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 17:24:30 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:61549 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbYAGWY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 17:24:29 -0500
Date: Mon, 7 Jan 2008 14:15:47 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       hpa@zytor.com
Subject: Re: [PATCH -mm/x86] revert i386: handle an initrd in highmem (Was
 Re: 2.6.24-rc6-mm1)
Message-Id: <20080107141547.7b60b738.randy.dunlap@oracle.com>
In-Reply-To: <alpine.LFD.0.99999.0801071736320.31637@localhost.localdomain>
References: <20071222233056.d652743e.akpm@linux-foundation.org>
	<20080107135038.GA19568@linux.vnet.ibm.com>
	<alpine.LFD.0.99999.0801071453070.31637@localhost.localdomain>
	<20080107145609.GA26652@elte.hu>
	<20080107082237.595b266a.randy.dunlap@oracle.com>
	<alpine.LFD.0.99999.0801071736320.31637@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2008 17:50:49 +0100 (CET) Thomas Gleixner wrote:

> On Mon, 7 Jan 2008, Randy Dunlap wrote:
> > On Mon, 7 Jan 2008 15:56:09 +0100 Ingo Molnar wrote:
> > > i'm also wondering - what would be the easiest way to integrate kexec 
> > > into an automated test environment. If i have a bzImage kernel, is kexec 
> > > still supposed to work? Could i for example do a reboot into a new 
> > > (kexec-enabled) kernel via kexec in essence?
> > 
> > My daily/nightly kernel test runs use kexec to boot the test kernel.
> > Well, did thru 2.6.24-rc6-git9, but they fail after that.
> > Hopefully this patch fixes things.
> 
> The patch in question is not in mainline, it's in the mm branch of
> x86.git. So the problem in mainline is a different one. Could you
> bisect it please ?

Ugh.  As happens during demos, this (kexec failure) won't happen for me
when I want it to.  I'll keep an eye out for it...


---
~Randy
