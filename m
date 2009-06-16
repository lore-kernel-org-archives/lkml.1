Return-Path: <linux-kernel-owner+w=401wt.eu-S1760237AbZFPBWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760237AbZFPBWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 21:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758276AbZFPBVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 21:21:54 -0400
Received: from mail001.aei.ca ([206.123.6.130]:49085 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752672AbZFPBVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 21:21:53 -0400
X-Greylist: delayed 476 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Jun 2009 21:21:53 EDT
From: Ed Tomlinson <edt@aei.ca>
To: Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Btrfs bug fix
Date: Mon, 15 Jun 2009 21:13:40 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.30-crc; KDE/4.2.4; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <20090616010045.GB3735@think>
In-Reply-To: <20090616010045.GB3735@think>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906152113.41352.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 June 2009 21:00:45 Chris Mason wrote:
> Hello,
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master
> 
> Has a fix for the new space balancing code (btrfs-vol -b).  The bug can
> trigger a corruption if you run the balancing with multiple subvolumes
> and unmount without doing anything in the subvolumes.
> 
> Yan Zheng (1) commits (+6/-6):
>     Btrfs: always update root items for fs trees at commit time
> 
> Total: (1) commits
> 
>  fs/btrfs/transaction.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

Does this apply when using newformat2 branch too?  If so, it looks like its not been updated.

TIA
Ed Tomlinson

