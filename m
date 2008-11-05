Return-Path: <linux-kernel-owner+w=401wt.eu-S1755825AbYKERIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbYKERIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 12:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbYKERIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 12:08:13 -0500
Received: from www.tglx.de ([62.245.132.106]:48845 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbYKERIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 12:08:12 -0500
Date: Wed, 5 Nov 2008 18:08:00 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: "Hans J. Koch" <hjk@linutronix.de>, Mike Frysinger <vapier@gentoo.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UIO: only call pgprot_noncached if defined
Message-ID: <20081105170800.GD6382@local>
References: <1225301177-21406-1-git-send-email-vapier@gentoo.org> <20081105113610.GA6382@local> <20081105163334.GA8473@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081105163334.GA8473@suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2008 at 08:33:34AM -0800, Greg KH wrote:
> On Wed, Nov 05, 2008 at 12:36:11PM +0100, Hans J. Koch wrote:
> > There seem to be archs that cannot easily implement a sensible
> > pgprot_noncached() function, so we should merge this patch. UIO doesn't
> > compile on these archs right now.
> 
> No, we should fix those arches to have that function at least NULLed
> out.  Isn't there only one, Blackfin?  Putting #ifdefs in .c files is
> not something we really want to do if at all possible.

Yep, 5 minutes after I sent the mail I regretted it. Blackfin could
easily implement an "empty" macro that just returns its parameter.

I hereby revoke my Signed-off-by, you're right.

Thanks,
Hans

> 
> thanks,
> 
> greg k-h
