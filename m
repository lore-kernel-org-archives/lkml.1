Return-Path: <linux-kernel-owner+w=401wt.eu-S1760126AbYD2Qwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760126AbYD2Qwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 12:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbYD2QwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 12:52:23 -0400
Received: from www.tglx.de ([62.245.132.106]:54399 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbYD2QwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 12:52:22 -0400
Date: Tue, 29 Apr 2008 18:51:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Miller <davem@davemloft.net>
cc: torvalds@linux-foundation.org, harvey.harrison@gmail.com, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bitops: remove "optimizations"
In-Reply-To: <20080429.053412.15412725.davem@davemloft.net>
Message-ID: <alpine.LFD.1.10.0804291843550.6003@apollo.tec.linutronix.de>
References: <alpine.LFD.1.10.0804281233090.3119@woody.linux-foundation.org> <alpine.LFD.1.10.0804291141580.3261@apollo.tec.linutronix.de> <20080429.030332.88897602.davem@davemloft.net> <20080429.053412.15412725.davem@davemloft.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Tue, 29 Apr 2008 03:03:32 -0700 (PDT)
> 
> > From: Thomas Gleixner <tglx@linutronix.de>
> > Date: Tue, 29 Apr 2008 12:01:02 +0200 (CEST)
> > 
> > > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > 
> > Acked-by: David S. Miller <davem@davemloft.net>
> 
> Ironically, I just bisected sparc64 bootup failures to the following
> changeset.  It's very late here, and I haven't looked into the
> details, but it seems to wedge in free_area_init_nodes() on a non-NUMA
> system with CONFIG_NUMA disabled.
> 
> Isn't it funny that this optimization not only was useless, but also
> broke things. :-/

The question is, whether it broke things or just unearthed some bug
hidden elsewhere.

Thanks,
	tglx
