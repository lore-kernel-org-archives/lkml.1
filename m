Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143AbYJOWzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbYJOWzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 18:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbYJOWz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 18:55:26 -0400
Received: from ns1.suse.de ([195.135.220.2]:50367 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753658AbYJOWz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 18:55:26 -0400
Date: Wed, 15 Oct 2008 15:51:34 -0700
From: Greg KH <gregkh@suse.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, stable@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, jesse.brandeburg@intel.com,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -stable] disable CONFIG_DYNAMIC_FTRACE due to possible
	memory corruption on module unload
Message-ID: <20081015225134.GA23026@suse.de>
References: <alpine.DEB.1.10.0810151815110.18960@gandalf.stny.rr.com> <alpine.DEB.1.10.0810151843130.19408@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810151843130.19408@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 06:46:12PM -0400, Steven Rostedt wrote:
> 
> On Wed, 15 Oct 2008, Steven Rostedt wrote:
> > 
> > The problem arises when we trace functions and modules are unloaded.
> 
> Note, it is not just module unloading. The issue can happen when the
> init functions of a module are freed and the nvram is vmapped there as
> well.

Ok, that makes sense why so many people hit this.

I'll go do a 2.6.27.1 with this patch in it right now, thanks for
spending the time to look into this.

greg k-h
