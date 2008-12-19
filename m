Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514AbYLSFmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbYLSFmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 00:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbYLSFmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 00:42:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48057 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbYLSFma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 00:42:30 -0500
Date: Fri, 19 Dec 2008 00:42:25 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Paul Mackerras <paulus@samba.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Milton Miller <miltonm@bga.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 0/5] powerpc: ftrace updates to previous patch series
In-Reply-To: <18763.10937.847276.371262@drongo.ozlabs.ibm.com>
Message-ID: <alpine.DEB.1.10.0812190032300.17609@gandalf.stny.rr.com>
References: <20081126215821.263324391@goodmis.org> <alpine.DEB.1.10.0811261749310.1501@gandalf.stny.rr.com> <20081128131014.GC26793@elte.hu> <alpine.DEB.1.10.0812011315020.7645@gandalf.stny.rr.com> <18763.10937.847276.371262@drongo.ozlabs.ibm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 19 Dec 2008, Paul Mackerras wrote:

> Steven Rostedt writes:
> 
> > Sorry, I rebased to edit the change log where I mispelled Paul's name.
> 
> So, what commits should I be pulling into powerpc.git, or what patches
> should I be committing, for dynamic ftrace on powerpc?

Ingo did not like the rebase and kept the original commits (the one with 
the change log with the incorrect spelling).

From: git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
  tracing/powerpc
====================================
commit 8fd6e5a8c81e2e9b912ea33c8425a10729db469b
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Fri Nov 14 16:21:19 2008 -0800

    powerpc: ftrace, convert to new dynamic ftrace arch API
    
    Impact: update to PowerPC ftrace arch API
    
    This patch converts PowerPC to use the new dynamic ftrace arch API.
    
    Thanks to Paul Mackennas for pointing out the mistakes of my original
    test_24bit_addr function.
    
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>
====================================

The branch in my tree 'ppc/ftrace' has not been changed since. The only 
reason the commits in my tree are different than the ones in tip was 
because I rebased to fixed the spelling in the change log.

From: git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
  ppc/ftrace
====================================
commit a3520364f9376943e4d6c76931bf4df8569fa555
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Fri Nov 14 16:21:19 2008 -0800

    powerpc: ftrace, convert to new dynamic ftrace arch API
    
    Impact: update to PowerPC ftrace arch API
    
    This patch converts PowerPC to use the new dynamic ftrace arch API.
    
    Thanks to Paul Mackerras for pointing out the mistakes of my original
    test_24bit_addr function.
    
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>
====================================

Take your pick for which to pull from.

Thanks,

-- Steve

