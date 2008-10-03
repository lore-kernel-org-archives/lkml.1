Return-Path: <linux-kernel-owner+w=401wt.eu-S1755035AbYJCA31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035AbYJCA31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 20:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbYJCA3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 20:29:19 -0400
Received: from www.tglx.de ([62.245.132.106]:56494 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795AbYJCA3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 20:29:18 -0400
Date: Fri, 3 Oct 2008 02:28:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jesse Brandeburg <jesse.brandeburg@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Olaf Kirch <okir@suse.de>,
       Jiri Kosina <jkosina@suse.cz>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-netdev@vger.kernel.org,
       kkeil@suse.de, agospoda@redhat.com, arjan@linux.intel.com,
       david.graham@intel.com, bruce.w.allan@intel.com, john.ronciak@intel.com,
       chris.jones@canonical.com, tim.gardner@intel.com, airlied@gmail.com,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] e1000e: prevent concurrent access to NVRAM
In-Reply-To: <4807377b0810021719m164e734cndaddb7006508cabc@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0810030226320.5549@apollo.tec.linutronix.de>
References: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com>  <20080930031952.22950.45228.stgit@jbrandeb-bw.jf.intel.com>  <Pine.LNX.4.64.0810021624380.1887@twin.jikos.cz>  <200810021703.43770.okir@suse.de>  <alpine.LFD.1.10.0810030041060.5549@apollo.tec.linutronix.de>
 <4807377b0810021719m164e734cndaddb7006508cabc@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008, Jesse Brandeburg wrote:

> On Thu, Oct 2, 2008 at 4:42 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > The confirmed bugs where the nvram acquire code was called
> > concurrently are still in your tree and the prevention patch along
> > with the resulting bugfixes are stuck in some obscure intel QA
> > process.
> >
> > Please apply at least the bug prevention patch below.
> 
> This is the same patch I posted 7 minutes ago, except that this patch
> without the e1000e changes applied before it will cause all sorts of
> WARN's to be printed during normal operation.  If at all possible I
> think they should stay together as a group to prevent un-necessary
> noise in the logs.

Sure, I'm all for the combo of those. I just wanted to get some motion
into this stale process.

     tglx
	
