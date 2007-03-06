Return-Path: <linux-kernel-owner+w=401wt.eu-S1752360AbXCFND2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbXCFND2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 08:03:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933914AbXCFND2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 08:03:28 -0500
Received: from www.osadl.org ([213.239.205.134]:42365 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752360AbXCFND0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 08:03:26 -0500
Subject: Re: [5/6] 2.6.21-rc2: known regressions
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Ingo Molnar <mingo@elte.hu>
Cc: Soeren Sonnenburg <kernel@nn7.de>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Emil Karlson <jkarlson@cc.hut.fi>, Len Brown <lenb@kernel.org>
In-Reply-To: <20070306125119.GA6119@elte.hu>
References: <Pine.LNX.4.64.0703051542030.3998@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0703051626490.3998@woody.linux-foundation.org>
	 <1173142948.24738.257.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0703051730230.3998@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0703051810030.3998@woody.linux-foundation.org>
	 <20070306103315.GA4295@mellanox.co.il> <20070306103712.GA10942@elte.hu>
	 <20070306104618.GA5792@mellanox.co.il> <1173180977.9161.14.camel@localhost>
	 <20070306120701.GA29599@elte.hu>  <20070306125119.GA6119@elte.hu>
Content-Type: text/plain
Date: Tue, 06 Mar 2007 14:09:29 +0100
Message-Id: <1173186570.24738.326.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-06 at 13:51 +0100, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > > BTW, Ingo, can you suspend/resume any number of times with this 
> > > > patch?
> > > 
> > > well I could at least two times in a row in my minimalistic setup 
> > > (config attached) however using the full kernel config it still 
> > > hangs ... (config also attached in case you watn to compare it).
> > 
> > i can confirm that with your full config i see a hang too. This is 
> > most likely the ACPI problem - we are debugging this now and will come 
> > up with a patch.
> 
> update: this only happens with simulation, and even then it's not a full 
> hang but 'hangs until i hit a key'. With real resume i'm hitting a real 
> key anyway so it doesnt hang.

Hmm. The key is consumed in the BIOS, so there should be no
interrupt. /me digs deeper.

	tglx


