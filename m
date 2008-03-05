Return-Path: <linux-kernel-owner+w=401wt.eu-S1751466AbYCENVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466AbYCENVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 08:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750786AbYCENVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 08:21:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53139 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbYCENVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 08:21:36 -0500
Date: Wed, 5 Mar 2008 14:21:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Roskin <proski@gnu.org>, Zan Lynx <zlynx@acm.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to use GPL-only
	symbols
Message-ID: <20080305132100.GB11701@elte.hu>
References: <alpine.LFD.1.00.0802290929590.17889@woody.linux-foundation.org> <1204313978.2316.8.camel@dv> <20080229211513.GI27212@elte.hu> <1204324265.2316.70.camel@dv> <20080303105752.GA23594@elte.hu> <20080304003723.z79pcavdk4wgoc44@webmail.spamcop.net> <20080304125744.GF29777@elte.hu> <alpine.LFD.1.00.0803040907420.12253@woody.linux-foundation.org> <20080304205117.GA21803@elte.hu> <Pine.LNX.4.64.0803050023090.18589@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803050023090.18589@twin.jikos.cz>
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


* Jiri Kosina <jkosina@suse.cz> wrote:

> On Tue, 4 Mar 2008, Ingo Molnar wrote:
> 
> > > Ingo, i's simply not possible to put ndiswrapper in user-space sanely.
> > > Drivers are drivers. They'll want (shared) interrupts, they want DMA, 
> > > they want to do things like cli/sti.
> > yeah, i agree that putting it into userspace is quite insane.
> > it might possible to do it halfways sanely via existing arch/x86/kvm/ 
> > infrastructure though. VMX/SVM context will properly emulate the IRQ 
> > flag so cli/sti will work fine, and as long as DMA is properly 
> > quarantined via an iommu it might even not corrupt the rest of the 
> > system. 
> 
> This definitely could be a [hackish] way to go. The remarkable 
> drawback is that it will not work on CPUs without virtualization 
> extensions.

by the time it's implemented and trickles into distributions the 
majority of PCs will have virtualization extensions.

	Ingo
