Return-Path: <linux-kernel-owner+w=401wt.eu-S933062AbXCJIsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933062AbXCJIsq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 03:48:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933426AbXCJIsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 03:48:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58842 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933062AbXCJIsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 03:48:45 -0500
Date: Sat, 10 Mar 2007 09:47:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Zachary Amsden <zach@vmware.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Andi Kleen <ak@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: PATCH: Fix VMI and COMPAT_VDSO for 2.6.21
Message-ID: <20070310084750.GA15647@elte.hu>
References: <45F2578E.3060907@vmware.com> <45F257C1.4070904@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F257C1.4070904@vmware.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Zachary Amsden <zach@vmware.com> wrote:

> Zachary Amsden wrote:
> >VMI is broken under COMPAT_VDSO, as Xen and other non hardware 
> >assisted hypervisors will be.  I have been working on a fix for this 
> >which works for older glibcs that panic when the new relocatable VDSO 
> >is used.  However, I believe at this time that the fix is going to be 
> >too radical to consider at this stage in the release of 2.6.21.  We 
> >don't expect this config option to be turned on by vendors for new 
> >distributions, so at this point we are willing to drop support for it 
> >when VMI is compiled in, and work on a patch for 2.6.22 which more 
> >fully addresses the problem.
> >
> >Please apply, thanks.

makes sense. We can do Jan's relocatable-COMPAT_VDSO thing in v2.6.22, 
but for v2.6.21 that's way too intrusive.

Acked-by: Ingo Molnar <mingo@elte.hu>

> I suppose it would be better if I attached the patch.

it certainly helps ;-)

	Ingo
