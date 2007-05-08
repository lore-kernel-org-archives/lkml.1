Return-Path: <linux-kernel-owner+w=401wt.eu-S1755618AbXEHHVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbXEHHVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 03:21:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755107AbXEHHVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 03:21:06 -0400
Received: from www.osadl.org ([213.239.205.134]:43528 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754910AbXEHHVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 03:21:03 -0400
Subject: Re: [PATCH 2/2] introduce I_SYNC
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       David Chinner <dgc@sgi.com>
In-Reply-To: <20070507220142.GC15054@lazybastard.org>
References: <20070507215913.GA15054@lazybastard.org>
	 <20070507220142.GC15054@lazybastard.org>
Content-Type: text/plain; charset=utf-8
Date: Tue, 08 May 2007 09:23:48 +0200
Message-Id: <1178609028.3042.275.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-08 at 00:01 +0200, Jörn Engel wrote:
> This patch is actually independent of LogFS.  It fixes a deadlock
> hidden in fs/fs-writeback.c that LogFS was unlucky enough to trigger.
> I strongly suspect NTFS triggered the same deadlock and "solved" it by
> introducing iget5_nowait().  For LogFS, iget5_nowait() would translate
> the deadlock into data corruption, so that is not an option.

Have you talked to NTFS folks about that ?

If it is a general problem, then please seperate the patch from logfs.

	tglx


