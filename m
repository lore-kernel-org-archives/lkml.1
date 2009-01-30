Return-Path: <linux-kernel-owner+w=401wt.eu-S1754989AbZA3F7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbZA3F7O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 00:59:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbZA3F67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 00:58:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:35563 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbZA3F66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 00:58:58 -0500
Date: Thu, 29 Jan 2009 21:56:39 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Maksim Yevmenkin <maksim.yevmenkin@gmail.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, will@crowder-design.com,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Fix OOPS in mmap_region() when merging adjacent
	VM_LOCKED file segments
Message-ID: <20090130055639.GA30950@suse.de>
References: <bb4a86c70901281151w4300605r3882461cd6e9774a@mail.gmail.com> <alpine.LFD.2.00.0901281316450.3123@localhost.localdomain> <1233259410.2315.75.camel@lts-notebook> <alpine.LFD.2.00.0901291228250.3123@localhost.localdomain> <alpine.LFD.2.00.0901291245170.3054@localhost.localdomain> <bb4a86c70901291447k5c5e90cfg34877b745825f5e2@mail.gmail.com> <alpine.LFD.2.00.0901291806340.3054@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901291806340.3054@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 06:08:30PM -0800, Linus Torvalds wrote:
> 
> 
> On Thu, 29 Jan 2009, Maksim Yevmenkin wrote:
> > 
> > Just to confirm. This patch also appear to fix the immediate issue for us.
> 
> Ok, I ended up committing it.
> 
> I didn't do the whole "Cc: stable@kernel.org" thing, because maybe the 
> non-cleanup version is less controversial for stable, but I decided that 
> there's no way I don't want the cleanup done in mainline kernel, and if we 
> end up needing a few VM_IO's added, I think it's worth it. Even after -rc3 
> (since I suspend we won't actually need them).

Which version was the "non-cleanup" version that should be added to the
stable trees?

The commit you did make, de33c8db5910cda599899dd431cc30d7c1018cbf,
seemed pretty "tiny" to me.

confused,

greg k-h
