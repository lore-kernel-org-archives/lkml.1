Return-Path: <linux-kernel-owner+w=401wt.eu-S1753230AbZKQCrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbZKQCrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 21:47:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbZKQCrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 21:47:04 -0500
Received: from THUNK.ORG ([69.25.196.29]:57666 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093AbZKQCrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 21:47:03 -0500
Date: Mon, 16 Nov 2009 21:43:18 -0500
From: Theodore Tso <tytso@mit.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
Subject: Re: [Bug #14620] WARNING: at mm/page_alloc.c:1805
	__alloc_pages_nodemask
Message-ID: <20091117024318.GC23066@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	=?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera> <xXQGFmujPl.A.SJG.7SdALB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <xXQGFmujPl.A.SJG.7SdALB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 11:37:47PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14620
> Subject		: WARNING: at mm/page_alloc.c:1805 __alloc_pages_nodemask
> Submitter	: Rogério Brito <rbrito@ime.usp.br>
> Date		: 2009-11-06 23:10 (11 days old)
> References	: http://marc.info/?l=linux-kernel&m=125754907413892&w=4

This isn't technically a regression, since the warning is simply
complaining about something that apparently ext4 has been doing for a
long time, which is that it allocates some very large order data
buffers.  So the change referenced simply printed a warning message
that complained about the fact.

The actual problem will be fixed in 2.6.32, as we no longer allocate
the big data buffers at mount time.

						- Ted
