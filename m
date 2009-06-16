Return-Path: <linux-kernel-owner+w=401wt.eu-S1762616AbZFPCKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762616AbZFPCKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 22:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711AbZFPCKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 22:10:32 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:19470 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758219AbZFPCKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 22:10:31 -0400
Date: Mon, 15 Jun 2009 22:09:27 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Ed Tomlinson <edt@aei.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs bug fix
Message-ID: <20090616020927.GD3735@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Ed Tomlinson <edt@aei.ca>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <20090616010045.GB3735@think> <200906152113.41352.edt@aei.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906152113.41352.edt@aei.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Source-IP: abhmt006.oracle.com [141.146.116.15]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4A36FF09.0262:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 09:13:40PM -0400, Ed Tomlinson wrote:
> On Monday 15 June 2009 21:00:45 Chris Mason wrote:
> > Hello,
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master
> > 
> > Has a fix for the new space balancing code (btrfs-vol -b).  The bug can
> > trigger a corruption if you run the balancing with multiple subvolumes
> > and unmount without doing anything in the subvolumes.
> > 
> > Yan Zheng (1) commits (+6/-6):
> >     Btrfs: always update root items for fs trees at commit time
> > 
> > Total: (1) commits
> > 
> >  fs/btrfs/transaction.c |   12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> Does this apply when using newformat2 branch too?  If so, it looks like its not been updated.

I've updated newformat2 as well.

-chris

