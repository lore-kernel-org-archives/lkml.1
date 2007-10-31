Return-Path: <linux-kernel-owner+w=401wt.eu-S1760951AbXJaWzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760951AbXJaWzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 18:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbXJaWzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 18:55:43 -0400
Received: from cantor.suse.de ([195.135.220.2]:33256 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbXJaWzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 18:55:42 -0400
Date: Wed, 31 Oct 2007 23:55:41 +0100
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Duane Griffin <duaneg@dghda.com>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: 2.6.23 regression: accessing invalid mmap'ed memory from gdb causes unkillable spinning
Message-ID: <20071031225541.GA28552@wotan.suse.de>
References: <e9e943910710301745u429b14fj6c5a66fcbf6b0efa@mail.gmail.com> <20071031041932.GA12189@wotan.suse.de> <alpine.LFD.0.999.0710310756220.30120@woody.linux-foundation.org> <20071031151934.GA19211@wotan.suse.de> <alpine.LFD.0.999.0710310854560.3340@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710310854560.3340@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2007 at 08:59:41AM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 31 Oct 2007, Nick Piggin wrote:
> > 
> > Well the patch is right, in the context of the regression I introduced
> > (and so it should probably go into 2.6.23).
> 
> Yeah, it probably is fine for -stable.
> 
> And if mine (which actually changes behaviour, in that it makes ptrace get 
> an access error) causes regressions, I guess we'll have to use that 
> compatible-with-old-behaviour one for 2.6.24 too.
> 
> But I just rebooted and tested - the cleaned-up patch does seem to work 
> fine, and I get "Cannot access memory at address <xyz>" rather than any 
> reported problem.
> 
> So I think I'll commit my version asap, and see if anybody reports that 
> they have a situation where they use ptrace() and expect zero back from a 
> shared mapping past the end.. And if there are issues, we can switch back 
> to the old broken behaviour with your patch,

No that would be great. Fingers crossed it won't cause any problems.

Thanks, all.
