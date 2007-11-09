Return-Path: <linux-kernel-owner+w=401wt.eu-S1758151AbXKIWPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151AbXKIWPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 17:15:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbXKIWPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 17:15:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40672 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbXKIWPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 17:15:32 -0500
Date: Fri, 9 Nov 2007 13:38:29 -0800
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: eranian@hpl.hp.com, perfmon@napali.hpl.hp.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix up perfmon to build on -mm
Message-ID: <20071109213829.GC28276@kroah.com>
References: <20071107003454.GA13374@kroah.com> <20071109120627.60ec9ab4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071109120627.60ec9ab4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2007 at 12:06:27PM -0800, Andrew Morton wrote:
> On Tue, 6 Nov 2007 16:34:54 -0800
> Greg KH <greg@kroah.com> wrote:
> 
> > Here's a patch against my current tree that gets the perfmon code
> > building and hopefully working.
> 
> Unfortunately I still haven't merged perfmon due to recently-occurring
> minor conflicts with Tony's ia64 tree and more major recently-occurring
> conflicts with the x86 tree.
> 
> There's not really a lot which Stephane can practically do about this -
> normally I'll just get down and fix stuff like this up.  But the impression
> I get from various people is that the perfmon tree in its present form
> would not be a popular merge.
> 
> The impression which people have (and I admit to sharing it) is that
> there's just too much stuff in there and it might not all be justifiable. 
> But I suspect that people have largely forgotten what is in there, and why
> it is in there.
> 
> We really need to get this ball rolling, and that will require a sustained
> effort from more people than just Stephane.  I suppose as a starting point
> we could yet again review the existing patches, please.  People will mainly
> concentrate upon the changelogging to understand which features are being
> proposed and why, so that submission should describe these things pretty
> carefully: what are the features and why do we need each of them.

Is there some way to rebase these patches/git tree to be a bit more easy
to review?  Right now there are over 75 patches in the tree and many (if
not most) can be removed by merging them with previous patches.

If someone could break this stuff down into reviewable pieces, it would
go a very long way toward making it acceptable.

Is there any way to just provide a basic framework that everyone can
agree on and then add on more stuff as time goes on?  Do we have to have
every different processor/arch with support to start with?

thanks,

greg k-h
