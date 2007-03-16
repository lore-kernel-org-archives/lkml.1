Return-Path: <linux-kernel-owner+w=401wt.eu-S933648AbXCPQbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933648AbXCPQbr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 12:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933916AbXCPQbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 12:31:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51190 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933648AbXCPQbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 12:31:45 -0400
Date: Fri, 16 Mar 2007 17:31:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Zachary Amsden <zach@vmware.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Beulich <jbeulich@novell.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: [RFC, PATCH] Fixup COMPAT_VDSO to work with CONFIG_PARAVIRT
Message-ID: <20070316163118.GA12999@elte.hu>
References: <45FA054F.6020107@vmware.com> <m17itho10v.fsf@ebiederm.dsl.xmission.com> <45FAC4EF.4060305@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45FAC4EF.4060305@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> > The practical question here is if we already have all of the 
> > relocation logic for the VDSO why do we need to add more?
> 
> The kernel doesn't normally ever relocate the vdso; [...]

that's what is the case right now, but much of the intention behind the 
vma based vDSO is to enable per-process randomized vdso locations, and 
various distributions do that. So the 'modern' vDSO concept is very much 
relocatable.

	Ingo
