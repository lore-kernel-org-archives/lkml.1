Return-Path: <linux-kernel-owner+w=401wt.eu-S1756669AbYAGQYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbYAGQYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 11:24:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755369AbYAGQYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 11:24:45 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:56081 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbYAGQYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 11:24:44 -0500
Date: Mon, 7 Jan 2008 08:22:37 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       hpa@zytor.com
Subject: Re: [PATCH -mm/x86] revert i386: handle an initrd in highmem (Was
 Re: 2.6.24-rc6-mm1)
Message-Id: <20080107082237.595b266a.randy.dunlap@oracle.com>
In-Reply-To: <20080107145609.GA26652@elte.hu>
References: <20071222233056.d652743e.akpm@linux-foundation.org>
	<20080107135038.GA19568@linux.vnet.ibm.com>
	<alpine.LFD.0.99999.0801071453070.31637@localhost.localdomain>
	<20080107145609.GA26652@elte.hu>
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

On Mon, 7 Jan 2008 15:56:09 +0100 Ingo Molnar wrote:

> 
> * Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Mon, 7 Jan 2008, Dhaval Giani wrote:
> > 
> > > Hi Andrew, Ingo, Thomas, Peter,
> > > 
> > > x86: revert i386: handle an initrd in highmem
> > > 
> > > The patch caused a failure while booting a kexec kernel.
> > > (http://lkml.org/lkml/2008/1/7/42 has the bisect details.)
> > > 
> > > The following patch reverts it.
> > > 
> > > Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> > 
> > Thanks for tracking this down. I'll pull the patch from the x86 git 
> > tree as well.
> 
> Dhaval, how about the other problem you had - do you have any guess 
> what it might be related to?
> 
> i'm also wondering - what would be the easiest way to integrate kexec 
> into an automated test environment. If i have a bzImage kernel, is kexec 
> still supposed to work? Could i for example do a reboot into a new 
> (kexec-enabled) kernel via kexec in essence?

My daily/nightly kernel test runs use kexec to boot the test kernel.
Well, did thru 2.6.24-rc6-git9, but they fail after that.
Hopefully this patch fixes things.


---
~Randy
