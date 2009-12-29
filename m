Return-Path: <linux-kernel-owner+w=401wt.eu-S1752829AbZL2Vue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbZL2Vue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 16:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbZL2Vud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 16:50:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40630 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbZL2Vuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 16:50:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [Bug #14899] reiserfs: inconsistent lock state
Date: Tue, 29 Dec 2009 22:51:16 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera> <NJVdobuNFNK.A.0O.fnhOLB@chimera> <20091229162858.GA5258@nowhere>
In-Reply-To: <20091229162858.GA5258@nowhere>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912292251.16427.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 December 2009, Frederic Weisbecker wrote:
> On Tue, Dec 29, 2009 at 04:09:57PM +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14899
> > Subject		: reiserfs: inconsistent lock state
> > Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
> > Date		: 2009-12-11 22:06 (19 days old)
> > References	: http://marc.info/?l=linux-kernel&m=126056920702515&w=4
> > Handled-By	: Frederic Weisbecker <fweisbec@gmail.com>
> > Patch		: http://patchwork.kernel.org/patch/67256/
> > 		  http://patchwork.kernel.org/patch/67257/
> > 
> > 
> 
> 
> I think this precise one is solved. The problem is that there are other
> vmalloc in the same path that also need to be fixed.
> 
> I have a pending patch for that but as there are other reiserfs lockdep
> reports to be solved, I'm trying to pack all fixes in a same
> set so that they can be tested using a simple merge.
> 
> For now, I guess this ticket shouldn't be closed until reporters
> can test the whole.

OK, thanks for the update.

Rafael
