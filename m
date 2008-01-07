Return-Path: <linux-kernel-owner+w=401wt.eu-S1757380AbYAGO4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380AbYAGO4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 09:56:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbYAGO4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 09:56:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38903 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605AbYAGO4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 09:56:35 -0500
Date: Mon, 7 Jan 2008 15:56:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       hpa@zytor.com
Subject: Re: [PATCH -mm/x86] revert i386: handle an initrd in highmem (Was
	Re: 2.6.24-rc6-mm1)
Message-ID: <20080107145609.GA26652@elte.hu>
References: <20071222233056.d652743e.akpm@linux-foundation.org> <20080107135038.GA19568@linux.vnet.ibm.com> <alpine.LFD.0.99999.0801071453070.31637@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.99999.0801071453070.31637@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Mon, 7 Jan 2008, Dhaval Giani wrote:
> 
> > Hi Andrew, Ingo, Thomas, Peter,
> > 
> > x86: revert i386: handle an initrd in highmem
> > 
> > The patch caused a failure while booting a kexec kernel.
> > (http://lkml.org/lkml/2008/1/7/42 has the bisect details.)
> > 
> > The following patch reverts it.
> > 
> > Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> 
> Thanks for tracking this down. I'll pull the patch from the x86 git 
> tree as well.

Dhaval, how about the other problem you had - do you have any guess 
what it might be related to?

i'm also wondering - what would be the easiest way to integrate kexec 
into an automated test environment. If i have a bzImage kernel, is kexec 
still supposed to work? Could i for example do a reboot into a new 
(kexec-enabled) kernel via kexec in essence?

	Ingo
