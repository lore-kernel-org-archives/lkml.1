Return-Path: <linux-kernel-owner+w=401wt.eu-S1760506AbXIYSbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760506AbXIYSbX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 14:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbXIYSbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 14:31:14 -0400
Received: from brick.kernel.dk ([87.55.233.238]:5307 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbXIYSbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 14:31:13 -0400
Date: Tue, 25 Sep 2007 20:32:36 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Berck E. Nash" <flyboy@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc7-mm1 AHCI ATA errors -- won't boot
Message-ID: <20070925183235.GD2367@kernel.dk>
References: <46F7FBCB.4030803@gmail.com> <46F8665A.4000206@garzik.org> <46F94FF3.1000400@gmail.com> <20070925182123.GC2367@kernel.dk> <46F95346.7090601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F95346.7090601@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25 2007, Berck E. Nash wrote:
> Jens Axboe wrote:
> > On Tue, Sep 25 2007, Berck E. Nash wrote:
> >> Jeff Garzik wrote:
> >>
> >>> The first step would be to clone the "upstream" branch of
> >>> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
> >>>
> >>> and see if the problem is reproducible there.  If yes, then you have
> >>> narrowed down the problem to something my ATA devel tree has introduced
> >>> into -mm.
> >> Nope, you're off the hook.  The libata tree works great, so it must be
> >> something else in -mm conflicting.
> 
> Whoops, sorry!  I just lied.  I'm a git newbie, and failed to actually
> get the "upstream" branch the first time, so rc8 is clean, but it fails
> when I actually pull the upstream branch.  I'll git bisect and get back
> to you.

OK, you probably realize this, but you can forget about the git-block
testing for now then.

-- 
Jens Axboe

