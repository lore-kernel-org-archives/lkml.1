Return-Path: <linux-kernel-owner+w=401wt.eu-S1752030AbZLWSwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbZLWSwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 13:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbZLWSwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 13:52:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43932 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbZLWSwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 13:52:31 -0500
Date: Wed, 23 Dec 2009 19:51:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Anthony Liguori <anthony@codemonkey.ws>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
Message-ID: <20091223185150.GA9587@elte.hu>
References: <4B1D4F29.8020309@gmail.com>
 <87637zdy9g.fsf@basil.nowhere.org>
 <4B30E654.40702@codemonkey.ws>
 <200912221701.56840.bzolnier@gmail.com>
 <4B30F214.80206@codemonkey.ws>
 <20091223065129.GA19600@elte.hu>
 <20091223101340.GC20539@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091223101340.GC20539@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > - Are a pure software concept and any compatibility mismatch is                                      
> >   self-inflicted. The patches are in fact breaking the ABI to KVM                                                
> 
> In practice, especially considering older kernel releases, VMs behave like 
> hardware, with all its quirks, compatibility requirements, sometimes not 
> fully understood, etc.

I stopped reading your reply here. That's not actually fully true of KVM, at 
all.

Virtualization isnt voodoo magic with some hidden souce in some magic hardware 
component that no-one can understand fully. This isnt some mystic hardware 
vendor coming up with some code and going away in the next quarter, with 
barely anything documented and thousands of users left with hardware 
components which we need to support under Linux somehow.

This is Linux virtualization, where _both_ the host and the guest source code 
is fully known, and bugs (if any) can be found with a high degree of 
determinism. This is Linux where the players dont just vanish overnight, and 
are expected to do a proper job.

Yes, there's (obviously) compatibility requirements and artifacts and past 
mistakes (as with any software interface), but you need to admit it to 
yourself that your "virtualization is sloppy just like hardware" claim is just 
a cheap excuse to not do a proper job of interface engineering.

Thanks,

	Ingo
