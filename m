Return-Path: <linux-kernel-owner+w=401wt.eu-S967441AbXEHMFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967441AbXEHMFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 08:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967438AbXEHMFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 08:05:48 -0400
Received: from lazybastard.de ([212.112.238.170]:58576 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967435AbXEHMFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 08:05:47 -0400
Date: Tue, 8 May 2007 14:00:40 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 2/2] introduce I_SYNC
Message-ID: <20070508120037.GB20637@lazybastard.org>
References: <20070507215913.GA15054@lazybastard.org> <20070507220142.GC15054@lazybastard.org> <1178609028.3042.275.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1178609028.3042.275.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007 09:23:48 +0200, Thomas Gleixner wrote:
> On Tue, 2007-05-08 at 00:01 +0200, Jörn Engel wrote:
> > This patch is actually independent of LogFS.  It fixes a deadlock
> > hidden in fs/fs-writeback.c that LogFS was unlucky enough to trigger.
> > I strongly suspect NTFS triggered the same deadlock and "solved" it by
> > introducing iget5_nowait().  For LogFS, iget5_nowait() would translate
> > the deadlock into data corruption, so that is not an option.
> 
> Have you talked to NTFS folks about that ?

Anton was on Cc: when I sent the first round of this patch.  He didn't
respond.

> If it is a general problem, then please seperate the patch from logfs.

The problem certainly is generic and the patch already seperate.  I can
resend it in a seperate thread if that is preferred.

Until yesterday it appeared as if LogFS was the only code that could
trigger the problem.  NTFS is hard to judge without maintainer comment.
By now it appears as if JFS and NFS have joined in.  Maybe I was
over-cautious in not sending it for some month.

Jörn

-- 
He that composes himself is wiser than he that composes a book.
-- B. Franklin
