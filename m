Return-Path: <linux-kernel-owner+w=401wt.eu-S1754054AbYJZLKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbYJZLKI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 07:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbYJZLJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 07:09:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53681 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbYJZLJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 07:09:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: [Bug #11805] mounting XFS produces a segfault
Date: Sun, 26 Oct 2008 12:14:27 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Tiago Maluta <maluta_tiago@yahoo.com.br>
References: <nw2Y6lk-0lG.A.VUB.RV5AJB@chimera> <t1C3RWL0r7M.A.x6C.AW5AJB@chimera> <20081026000804.GC11948@disturbed>
In-Reply-To: <20081026000804.GC11948@disturbed>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810261214.28369.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 26 of October 2008, Dave Chinner wrote:
> On Sat, Oct 25, 2008 at 10:06:44PM +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.27.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11805
> > Subject		: mounting XFS produces a segfault
> > Submitter	: Tiago Maluta <maluta_tiago@yahoo.com.br>
> > Date		: 2008-10-21 18:00 (5 days old)
> 
> Ah - this was reported as a 2.6.26 -> 2.6.27 regression, not a
> .27->.28-rcX regression.
> 
> Even so, it's not obviously an XFS regression as the problem is
> that alloc_pages(GFP_KERNEL) is the new failure on .27. The fact
> that XFS never handled the allocation failure is not a new bug
> or regression - it has never caught failures during log
> allocation...
> 
> So really, if you want to look for a regression here, it is the
> change of behaviour in the VM leading to a memory allocation failure
> where it has never, ever previously failed...

OK, I moved it to the list of regressions introduced between .26 and .27.

Thanks,
Rafael
