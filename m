Return-Path: <linux-kernel-owner+w=401wt.eu-S1763003AbXEPVkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763003AbXEPVkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 17:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759818AbXEPVkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 17:40:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759572AbXEPVkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 17:40:32 -0400
Date: Wed, 16 May 2007 22:39:47 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Udo van den Heuvel <udovdh@xs4all.nl>
Cc: device-mapper development <dm-devel@redhat.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Subject: Re: [dm-devel] Re: BUG in kcryptd?
Message-ID: <20070516213946.GS6509@agk.fab.redhat.com>
Mail-Followup-To: Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Udo van den Heuvel <udovdh@xs4all.nl>,
	device-mapper development <dm-devel@redhat.com>,
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>
References: <464B1F2B.3030009@xs4all.nl> <Pine.LNX.4.61.0705161751020.9570@yvahk01.tjqt.qr> <20070516112947.faf95c22.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070516112947.faf95c22.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 11:29:47AM -0700, Andrew Morton wrote:
> On Wed, 16 May 2007 17:52:09 +0200 (MEST)
> Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
> > On May 16 2007 17:11, Udo van den Heuvel wrote:
> > >While opening an encrypted partition and trying to fsck it:
> > Yeah, somewhere is a bug in it, I also get an oops with
> > kcryptd in 2.6.20 on sparc64 after a few minutes (though,
> > it's a NULL dereference there).
> guys, please do try to copy the appropriate mailing list on bug reports,
> thanks.
 
Please test against 2.6.22-rc1 which includes relevant patches like
dm-crypt-fix-call-to-clone_init.patch

Alasdair
-- 
agk@redhat.com
