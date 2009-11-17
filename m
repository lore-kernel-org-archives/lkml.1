Return-Path: <linux-kernel-owner+w=401wt.eu-S1756760AbZKQWwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbZKQWwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:52:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756605AbZKQWw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:52:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38756 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756603AbZKQWwZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:52:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: [Bug #14620] WARNING: at mm/page_alloc.c:1805 __alloc_pages_nodemask
Date: Tue, 17 Nov 2009 23:53:50 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc7-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       =?iso-8859-1?q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera> <xXQGFmujPl.A.SJG.7SdALB@chimera> <20091117024318.GC23066@mit.edu>
In-Reply-To: <20091117024318.GC23066@mit.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200911172353.50156.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 November 2009, Theodore Tso wrote:
> On Mon, Nov 16, 2009 at 11:37:47PM +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.31.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14620
> > Subject		: WARNING: at mm/page_alloc.c:1805 __alloc_pages_nodemask
> > Submitter	: Rogério Brito <rbrito@ime.usp.br>
> > Date		: 2009-11-06 23:10 (11 days old)
> > References	: http://marc.info/?l=linux-kernel&m=125754907413892&w=4
> 
> This isn't technically a regression, since the warning is simply
> complaining about something that apparently ext4 has been doing for a
> long time, which is that it allocates some very large order data
> buffers.  So the change referenced simply printed a warning message
> that complained about the fact.
> 
> The actual problem will be fixed in 2.6.32, as we no longer allocate
> the big data buffers at mount time.

Thanks, I'm going to close the bug.

Rafael
