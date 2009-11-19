Return-Path: <linux-kernel-owner+w=401wt.eu-S1757199AbZKSQTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbZKSQTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 11:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756651AbZKSQTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 11:19:31 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:12620 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756499AbZKSQTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 11:19:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iLTuYd3CWoDBOtkwim0aJwXQkBxgZwc0mNu76YYN4eyHjd32WzrDu5Pn1Z361BsgUh
         DNYj9QRufUy9wF5obbLSdzJfor7Y+Ib0zbgEejyc00TY8VlIaENEWfAexVFdkHkGIhwz
         p81kaQrr+jwnd5g0Mmq5N/nOMCLDARWTSYzi0=
Date: Thu, 19 Nov 2009 17:19:36 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Haley <aph@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
Message-ID: <20091119161934.GD4967@nowhere>
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain> <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org> <20091119072040.GA23579@elte.hu> <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain> <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain> <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain> <4B0567E0.5080803@redhat.com> <1258646552.22249.493.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258646552.22249.493.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 11:02:32AM -0500, Steven Rostedt wrote:
> On Thu, 2009-11-19 at 15:44 +0000, Andrew Haley wrote:
> > Thomas Gleixner wrote:
> 
> > We're aligning the stack properly, as per the ABI requirements.  Can't
> > you just fix the tracer?
> 
> And how do we do that? The hooks that are in place have no idea of what
> happened before they were called?
> 
> -- Steve


Yep, this is really something we can't fix from the tracer....

