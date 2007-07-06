Return-Path: <linux-kernel-owner+w=401wt.eu-S1762393AbXGFAjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762393AbXGFAjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 20:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760269AbXGFAi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 20:38:56 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:34911 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758603AbXGFAiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 20:38:54 -0400
Date: Thu, 5 Jul 2007 18:38:53 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Karel Zak <kzak@redhat.com>
Cc: Mike Frysinger <vapier@gentoo.org>, Christoph Hellwig <hch@infradead.org>,
       List util-linux-ng <util-linux-ng@vger.kernel.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng 2.13-rc1
Message-ID: <20070706003853.GC3527@parisc-linux.org>
References: <20070703221156.GY14825@petra.dvoda.cz> <20070704084211.GA19128@infradead.org> <200707051242.00625.vapier@gentoo.org> <20070705213020.GB14825@petra.dvoda.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070705213020.GB14825@petra.dvoda.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2007 at 11:30:20PM +0200, Karel Zak wrote:
> > > >  The package build system is now based on autotools. The build system
> > > >  supports  separate CFLAGS and LDFLAGS for suid programs (SUID_CFLAGS,
> > > >  SUID_LDFLAGS). For more details see the README file
> > >
> > > And this is really dumb.  autotools is a completely pain in the ass and
> 
>  Well, Adrian Bunk added autotools stuff to util-linux during his work
>  on v2.13. This stuff has been fixed and stabilized in util-linux-ng
>  v2.13.
> 
>  I'm not fanatical autotools protagonist, but it seems useful in
>  util-linux. We will see...
> 
>  I'm ready to change or fix arbitrary thing in util-linux-ng, but I
>  always need a real reason -- bug report, new feature, or so. This
>  discussion is about impressions and feelings only.

No, it's based on long, hard and painful experiences attempting to debug
the fuckups that autoconf creates when it goes wrong.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
