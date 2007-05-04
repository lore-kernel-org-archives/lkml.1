Return-Path: <linux-kernel-owner+w=401wt.eu-S1030767AbXEDPfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030767AbXEDPfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 11:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030814AbXEDPfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 11:35:42 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:39590 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030767AbXEDPfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 11:35:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=O2adAmI95/O5Gj/acrJ9uEL7cLe3yTy1kMLQX5/9qNCgKm+aM4p13KnlTDOU9Qh+Hm2zrbNY+lTBORNc9p+D9ehGhLksR/pPzfOmimQLmZkygjudQ4oJu4Wf1IfWHQnoIHSdNrLL+H2/EiZa/LxEZh9dWxzHvy/mRm6lFfx9Z/I=
Date: Fri, 4 May 2007 17:34:38 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Strange soft lockup detected message (looks like spin_lock bug in pcnet32)
Message-ID: <20070504153438.GE24769@slug>
References: <20070503203143.GA8753@csclub.uwaterloo.ca> <20070504141024.GB8753@csclub.uwaterloo.ca> <20070504143326.GD24769@slug> <20070504151934.GA8754@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070504151934.GA8754@csclub.uwaterloo.ca>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2007 at 11:19:34AM -0400, Lennart Sorensen wrote:
> On Fri, May 04, 2007 at 04:33:26PM +0200, Frederik Deweerdt wrote:
> > On Fri, May 04, 2007 at 10:10:24AM -0400, Lennart Sorensen wrote:
> > > On Thu, May 03, 2007 at 04:31:43PM -0400, Lennart Sorensen wrote:
> > [...]
> > > Should line 2563 be a spin_lock_irqsave instead along with the
> > > appropriate unluck later?
> > IIRC, when you enable lockdep, it will complain about spinlocks used in
> > an invalid context.
> 
> What is lockdep and how do I enable it?
For the "what" part, see Documentation/lockdep-design.txt. You'll enable
it by with SPINLOCK_DEBUG, indeed.
> 
> I enabled SPINLOCK_DEBUG and am going to try that kernel now (except it
> hit the bug before I could even log in and install the kernel this time,
> so another reboot first).
> 
> --
> Len Sorensen
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
