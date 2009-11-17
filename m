Return-Path: <linux-kernel-owner+w=401wt.eu-S1753718AbZKQWVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbZKQWVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:21:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbZKQWVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:21:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38539 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbZKQWVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:21:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: [Bug #14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Tue, 17 Nov 2009 23:23:11 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc7-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Frank Mayhar <fmayhar@google.com>, Holger Freyther <zecke@selfish.org>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera> <xXQGFmujPl.A.6w.YUdALB@chimera> <20091117020202.GA23066@mit.edu>
In-Reply-To: <20091117020202.GA23066@mit.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911172323.11224.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 November 2009, Theodore Tso wrote:
> On Mon, Nov 16, 2009 at 11:37:39PM +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.31.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14354
> > Subject		: Bad corruption with 2.6.32-rc1 and upwards
> > Submitter	: Holger Freyther <zecke@selfish.org>
> > Date		: 2009-10-09 15:42 (39 days old)
> 
> Um, this was marked as resolved, until you reopened it and then reset
> the state to New.  Why did you do this?

I wasn't quite sure what the status was, because there was some activity in the
bug entry after it had been marked as resolved.

> It's fixed in mainline as of commit d4da6c9 when Linus reverted commit
> d0646f7.  Users could still see it if they mount a file system with -o
> journal_checksum, but (a) it's no longer the default, and (b)
> corruption if you use the non-default journal_checksum mount option is
> not a regression.
> 
> We have fixes to make journal_checksum safe queued for 2.6.33, but the
> revert fixes the regression problem.

OK, great, thanks for the confirmation.

I'll close it now.

Best,
Rafael
