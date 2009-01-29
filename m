Return-Path: <linux-kernel-owner+w=401wt.eu-S1755067AbZA2S0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbZA2S0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 13:26:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbZA2S0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 13:26:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:49390 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbZA2S0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 13:26:15 -0500
Date: Thu, 29 Jan 2009 10:14:22 -0800
From: Greg KH <gregkh@suse.de>
To: mtk.manpages@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Willy Tarreau <w@1wt.eu>, Bron Gondwana <brong@fastmail.fm>
Subject: Re: [patch] drop epoll max_user_instances and rely only on
	max_user_watches
Message-ID: <20090129181422.GA30935@suse.de>
References: <alpine.DEB.1.10.0901282010250.21401@alien.or.mcafeemobile.com> <20090129005716.6dd51929.akpm@linux-foundation.org> <cfd18e0f0901290203r139cb5bfgc02a0dcb1347aba8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfd18e0f0901290203r139cb5bfgc02a0dcb1347aba8@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 11:03:37PM +1300, Michael Kerrisk wrote:
> On Thu, Jan 29, 2009 at 9:57 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> >> Subject: [patch] drop epoll max_user_instances and rely only on max_user_watches
> >
> > nanonit: please prepare titles in the form "subsystem-id:
> > what-i-did-to-it", so a suitable name here would be
> >
> >        epoll: drop max_user_instances and rely only on max_user_watches
> >
> > On Wed, 28 Jan 2009 20:56:07 -0800 (PST) Davide Libenzi <davidel@xmailserver.org> wrote:
> >
> >> Linus suggested to put limits where the money is, and max_user_watches
> >> already does that w/out the need of max_user_instances. That has the
> >> advantage to mitigate the potential DoS while allowing pretty generous
> >> default behavior.
> 
> [...]
> 
> > I assume that because you based all this on all the other patches, you
> > view it as 2.6.30 material?
> 
> Since max_user_instances was added in 2.6.28, and this is an ABI
> change, I suggest this should go into .29-rc, so that
> max_user_instances spends as little time in the wild as possible.

I agree.  I'll backport the change to the .28 and .27 stable kernels as
well, as we have complaints about the default values breaking people's
machines.

thanks,

greg k-h
