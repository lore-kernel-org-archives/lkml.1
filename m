Return-Path: <linux-kernel-owner+w=401wt.eu-S1756650AbZLYUdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650AbZLYUdI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 15:33:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756289AbZLYUdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 15:33:06 -0500
Received: from one.firstfloor.org ([213.235.205.2]:47649 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbZLYUdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 15:33:06 -0500
Date: Fri, 25 Dec 2009 21:33:04 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mark Hounschell <markh@compro.net>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "dmarkh@cfl.rr.com" <dmarkh@cfl.rr.com>, Alain Knaff <alain@knaff.lu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "fdutils@fdutils.linux.lu" <fdutils@fdutils.linux.lu>,
       "Li, Shaohua" <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Fdutils] DMA cache consistency bug introduced in 2.6.28
Message-ID: <20091225203304.GA22306@basil.fritz.box>
References: <1261525076.16916.4.camel@localhost.localdomain> <4B3162BC.9000508@cfl.rr.com> <4B3214EC.6020308@compro.net> <6598A4E21F1DB24D80BF72956484F59802EFD1C6@orsmsx001.amr.corp.intel.com> <4B32386B.2060509@compro.net> <alpine.LFD.2.00.0912230828230.6879@localhost.localdomain> <87bphpd4rt.fsf@basil.nowhere.org> <alpine.LFD.2.00.0912230845550.6879@localhost.localdomain> <20091223170832.GH20539@basil.fritz.box> <20091225132116.6c9089f2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091225132116.6c9089f2@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 25, 2009 at 01:21:16PM +0100, Arjan van de Ven wrote:
> On Wed, 23 Dec 2009 18:08:32 +0100
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > I removed that code when moving to 64bit (floppy driver disabling C1),
> > but perhaps we need some variant of it again (but it's the first such
> > report in many years). Although it would be sad to have it again on
> > all systems.
> 
> at least now we have the pmqos infrastructure, driver just needs to ask
> for 0 latency ;)

Does pmqos work with apci=off etc.? I didn't think it shut down
the classic "HLT" idle, does it? The old i386 systems needed that
apparently, they long pre date any deeper idle states.

Anyways the code is still there for 32bit.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
