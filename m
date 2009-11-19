Return-Path: <linux-kernel-owner+w=401wt.eu-S1753622AbZKSSfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbZKSSfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 13:35:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZKSSfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 13:35:18 -0500
Received: from www.tglx.de ([62.245.132.106]:45511 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059AbZKSSfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 13:35:17 -0500
Date: Thu, 19 Nov 2009 19:31:51 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Guenther <richard.guenther@gmail.com>
cc: rostedt@goodmis.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
In-Reply-To: <84fc9c000911191003t244eb864o3d5b355ab5485f@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0911191931050.24119@localhost.localdomain>
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain>  <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org>  <20091119072040.GA23579@elte.hu>  <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain> 
 <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain>  <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain>  <alpine.LFD.2.00.0911190934070.2793@localhost.localdomain>  <1258653562.22249.682.camel@gandalf.stny.rr.com>
 <84fc9c000911191003t244eb864o3d5b355ab5485f@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Nov 2009, Richard Guenther wrote:
> Note that I only can reproduce the issue with
> -mincoming-stack-boundary=2, not with -mpreferred-stack-boundary=2.
> And
> you didn't provide us with a testcase either ... so please open
> a bugzilla and attach preprocessed source of a file that
> shows the problem, note the function it happens in and provide
> the command-line options you used for building.

http://gcc.gnu.org/bugzilla/show_bug.cgi?id=42109

Thanks,

	tglx
