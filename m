Return-Path: <linux-kernel-owner+w=401wt.eu-S1763040AbYEFMv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763040AbYEFMv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 08:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755201AbYEFMvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 08:51:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36820 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599AbYEFMvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 08:51:46 -0400
Date: Tue, 6 May 2008 14:51:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: travis@sgi.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86: Unify current.h
Message-ID: <20080506125128.GA5051@elte.hu>
References: <Pine.LNX.4.64.0805051146210.11469@schroedinger.engr.sgi.com> <20080506122841.GK32591@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506122841.GK32591@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Christoph Lameter <clameter@sgi.com> wrote:
> 
> > There are just two definitions that are shared but the resulting 
> > combined file is resonably small. Putting these two arch headers 
> > together shows that further unifications requires a unification of the 
> > per cpu / pda handling between both arches (zero based or some 
> > variation thereof).
> > 
> > Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> applied, thanks Christoph.

x86.git testing found a build failure due to this patch:

  include/asm/current.h: Assembler messages:
  include/asm/current.h:4: Error: no such instruction: `struct task_struct'

with this config:

  http://redhat.com/~mingo/misc/config-Tue_May__6_14_45_51_CEST_2008.bad

i suspect the __ASSEMBLY__ protections in the unified file are not wide 
enough?

	Ingo
