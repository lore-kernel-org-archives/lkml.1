Return-Path: <linux-kernel-owner+w=401wt.eu-S1757956AbYAGQdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956AbYAGQdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 11:33:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755629AbYAGQc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 11:32:58 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:32790 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253AbYAGQc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 11:32:57 -0500
Date: Mon, 7 Jan 2008 22:02:43 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       hpa@zytor.com
Subject: Re: [PATCH -mm/x86] revert i386: handle an initrd in highmem (Was
	Re: 2.6.24-rc6-mm1)
Message-ID: <20080107163243.GB20097@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20071222233056.d652743e.akpm@linux-foundation.org> <20080107135038.GA19568@linux.vnet.ibm.com> <alpine.LFD.0.99999.0801071453070.31637@localhost.localdomain> <20080107145609.GA26652@elte.hu> <20080107082237.595b266a.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080107082237.595b266a.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2008 at 08:22:37AM -0800, Randy Dunlap wrote:
> On Mon, 7 Jan 2008 15:56:09 +0100 Ingo Molnar wrote:
> 
> > 
> > * Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> > > On Mon, 7 Jan 2008, Dhaval Giani wrote:
> > > 
> > > > Hi Andrew, Ingo, Thomas, Peter,
> > > > 
> > > > x86: revert i386: handle an initrd in highmem
> > > > 
> > > > The patch caused a failure while booting a kexec kernel.
> > > > (http://lkml.org/lkml/2008/1/7/42 has the bisect details.)
> > > > 
> > > > The following patch reverts it.
> > > > 
> > > > Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> > > 
> > > Thanks for tracking this down. I'll pull the patch from the x86 git 
> > > tree as well.
> > 
> > Dhaval, how about the other problem you had - do you have any guess 
> > what it might be related to?
> > 
> > i'm also wondering - what would be the easiest way to integrate kexec 
> > into an automated test environment. If i have a bzImage kernel, is kexec 
> > still supposed to work? Could i for example do a reboot into a new 
> > (kexec-enabled) kernel via kexec in essence?
> 
> My daily/nightly kernel test runs use kexec to boot the test kernel.
> Well, did thru 2.6.24-rc6-git9, but they fail after that.
> Hopefully this patch fixes things.
> 

hmmm. I don't think so. This revert is from the x86 git tree (-mm) (I think
targetted for 2.6.25). Probably a bisect might help there.

-- 
regards,
Dhaval
