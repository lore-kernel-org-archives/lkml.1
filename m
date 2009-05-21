Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbZEUJbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbZEUJbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 05:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753951AbZEUJbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 05:31:20 -0400
Received: from www.tglx.de ([62.245.132.106]:34459 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457AbZEUJbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 05:31:18 -0400
Date: Thu, 21 May 2009 11:30:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhltc@us.ibm.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the tip-core tree with Linus' tree
In-Reply-To: <4A14D0FF.60202@us.ibm.com>
Message-ID: <alpine.LFD.2.00.0905211129480.3570@localhost.localdomain>
References: <20090521113902.3deb5031.sfr@canb.auug.org.au> <4A14D0FF.60202@us.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 May 2009, Darren Hart wrote:

> Stephen Rothwell wrote:
> > Hi all,
> > 
> > Today's linux-next merge of the tip-core tree got a conflict in
> > kernel/futex.c between commit 64d1304a64477629cb16b75491a77bafe6f86963
> > ("futex: setup writeable mapping for futex ops which modify user space
> > data") from Linus' tree and a couple of commits from the tip-core tree.
> > 
> > I fixed it up (see below - but please check in particular, I have no idea
> > if the call to get_futex_key() in futex_wait_requeue_pi() should take
> > VERIFY_READ or VERIFY_WRITE).
> > 
> > I can carry this fixup as necessary.
> 
> I suspect Thomas will be catching that up in the next day or so in tip
> (or I can).  If you need something now, the uaddr is VERIFY_READ and
> uaddr2 is VERIFY_WRITE.  See below...

Fix is in -tip and queued for -next

Thanks,

	tglx
