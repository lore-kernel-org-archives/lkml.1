Return-Path: <linux-kernel-owner+w=401wt.eu-S1763092AbZCQN0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763092AbZCQN0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 09:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756538AbZCQN0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 09:26:22 -0400
Received: from www.tglx.de ([62.245.132.106]:51533 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755189AbZCQN0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 09:26:21 -0400
Date: Tue, 17 Mar 2009 14:25:18 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: cleanup code changing
In-Reply-To: <1237289198.10142.1.camel@ht.satnam>
Message-ID: <alpine.LFD.2.00.0903171414270.29264@localhost.localdomain>
References: <1237289198.10142.1.camel@ht.satnam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Mar 2009, Jaswinder Singh Rajput wrote:

> The following changes since commit 1f31834fbbb8de367914f044d3268c6afbfdd783:
>   Ingo Molnar (1):
>         Merge branch 'x86/mce2'
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-cpu.git master
> 
> Jaswinder Singh Rajput (2):
>       x86: cpu/intel.c cleanup
>       x86: mpparse cleanup

I asked for separate patches which do mechanical cleanup and
structural code changes. Just seperating intel.c and mpparse.c patches
from the others is _NOT_ what I asked for.

The include reordering, #ifdef annotation and random changes of white
space and comments have absolutely nothing to do with the structural
changes in the code.

So what we want is: 
   one patch doing mechanical cleanups
   patch(es) which change the code flow

   for the code flow changes we want one patch per modification: e.g:

   P1: simplify A
   P2: simplify B
   ...

That way the mechanical cleanups can be verified as zero changes and
the patches which change the code flow are small and can be reviewed
easily.

Thanks,

	tglx
