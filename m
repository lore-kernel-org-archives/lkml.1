Return-Path: <linux-kernel-owner+w=401wt.eu-S1757213AbYAGPTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbYAGPTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 10:19:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbYAGPTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 10:19:32 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:40136 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbYAGPTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 10:19:31 -0500
Date: Mon, 7 Jan 2008 20:49:19 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [PATCH -mm/x86] revert i386: handle an initrd in highmem (Was
	Re: 2.6.24-rc6-mm1)
Message-ID: <20080107151919.GA7011@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20071222233056.d652743e.akpm@linux-foundation.org> <20080107135038.GA19568@linux.vnet.ibm.com> <alpine.LFD.0.99999.0801071453070.31637@localhost.localdomain> <20080107145609.GA26652@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080107145609.GA26652@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2008 at 03:56:09PM +0100, Ingo Molnar wrote:
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

other problem? The load_balance_monitor one? (We are still looking into
that one, just seems that se (as usual :) ) is turning out to be null).

> i'm also wondering - what would be the easiest way to integrate kexec 
> into an automated test environment. If i have a bzImage kernel, is kexec 
> still supposed to work? Could i for example do a reboot into a new 
> (kexec-enabled) kernel via kexec in essence?
> 

Yes, I use a bzImage kernel to reboot using kexec. I use a script which
just sets it up for me. (I can send it to you separately).

-- 
regards,
Dhaval
