Return-Path: <linux-kernel-owner+w=401wt.eu-S1754313AbZKSSnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbZKSSnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 13:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbZKSSnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 13:43:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753212AbZKSSnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 13:43:19 -0500
Date: Thu, 19 Nov 2009 10:41:09 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Haley <aph@redhat.com>
cc: Richard Guenther <richard.guenther@gmail.com>, rostedt@goodmis.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
In-Reply-To: <4B058CCD.8050605@redhat.com>
Message-ID: <alpine.LFD.2.00.0911191039470.2793@localhost.localdomain>
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain>   <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org>   <20091119072040.GA23579@elte.hu>   <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain>  
 <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain>   <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain>   <alpine.LFD.2.00.0911190934070.2793@localhost.localdomain>   <1258653562.22249.682.camel@gandalf.stny.rr.com>
 <84fc9c000911191003t244eb864o3d5b355ab5485f@mail.gmail.com> <4B058CCD.8050605@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 19 Nov 2009, Andrew Haley wrote:
> 
> I've got all that off-list.  I found the cause, and replied in another
> email.  It's not a bug.

Oh Gods, are we back to gcc people saying "sure, we do stupid things, but 
it's allowed, so we don't consider it a bug because it doesn't matter that 
real people care about real life, we only care about some paper, and real 
life doesn't matter, if it's 'undefined' we can make our idiotic choices 
regardless of what people need, and regardless of whether it actually 
generates better code or not".

		Linus
