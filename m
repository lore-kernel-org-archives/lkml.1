Return-Path: <linux-kernel-owner+w=401wt.eu-S933153AbZKXPGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153AbZKXPGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:06:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933093AbZKXPGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:06:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932900AbZKXPGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:06:46 -0500
Date: Tue, 24 Nov 2009 10:06:04 -0500
From: Jakub Jelinek <jakub@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Haley <aph@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>,
       rostedt@goodmis.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       Richard Guenther <richard.guenther@gmail.com>, gcc <gcc@gcc.gnu.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][GIT PULL][v2.6.32] tracing/x86: Add check to detect GCC messing with mcount prologue
Message-ID: <20091124150604.GJ22813@hs20-bc2-1.build.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain> <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain> <1258694593.22249.1012.camel@gandalf.stny.rr.com> <1258736456.22249.1032.camel@gandalf.stny.rr.com> <4B06EF6F.2050507@redhat.com> <6dc9ffc80911220138y15bfa91agccf5c29f1c30e09a@mail.gmail.com> <4B0972C9.302@redhat.com> <6dc9ffc80911221530t38d83cf6je739743c8d756667@mail.gmail.com> <4B0BF119.4070704@redhat.com> <alpine.LFD.2.00.0911241555170.24119@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0911241555170.24119@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 03:55:49PM +0100, Thomas Gleixner wrote:
> > you should compile your code with -maccumulate-outgoing-args, and there's
> > no need to use -mtune=generic.  Is that right?
> 
> Seems to work. What other side effects has that ?

Faster code, significant increase in code size though.  Note that on many
architectures it is the only supported model.

	Jakub
