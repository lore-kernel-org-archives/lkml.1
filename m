Return-Path: <linux-kernel-owner+w=401wt.eu-S1755716AbZKQCGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbZKQCGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 21:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755449AbZKQCGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 21:06:24 -0500
Received: from THUNK.ORG ([69.25.196.29]:36371 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942AbZKQCGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 21:06:23 -0500
Date: Mon, 16 Nov 2009 21:02:02 -0500
From: Theodore Tso <tytso@mit.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Frank Mayhar <fmayhar@google.com>, Holger Freyther <zecke@selfish.org>
Subject: Re: [Bug #14354] Bad corruption with 2.6.32-rc1 and upwards
Message-ID: <20091117020202.GA23066@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Frank Mayhar <fmayhar@google.com>,
	Holger Freyther <zecke@selfish.org>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera> <xXQGFmujPl.A.6w.YUdALB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xXQGFmujPl.A.6w.YUdALB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 11:37:39PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14354
> Subject		: Bad corruption with 2.6.32-rc1 and upwards
> Submitter	: Holger Freyther <zecke@selfish.org>
> Date		: 2009-10-09 15:42 (39 days old)

Um, this was marked as resolved, until you reopened it and then reset
the state to New.  Why did you do this?

It's fixed in mainline as of commit d4da6c9 when Linus reverted commit
d0646f7.  Users could still see it if they mount a file system with -o
journal_checksum, but (a) it's no longer the default, and (b)
corruption if you use the non-default journal_checksum mount option is
not a regression.

We have fixes to make journal_checksum safe queued for 2.6.33, but the
revert fixes the regression problem.

						- Ted
