Return-Path: <linux-kernel-owner+w=401wt.eu-S1760760AbZE0Gc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760760AbZE0Gc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 02:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759028AbZE0Gct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 02:32:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752895AbZE0Gcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 02:32:48 -0400
Date: Tue, 26 May 2009 23:32:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Martin Knoblauch <spamtrap@knobisoft.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [Bug #13178] Booting very slow
Message-Id: <20090526233244.b817948e.akpm@linux-foundation.org>
In-Reply-To: <200905260104.04844.rjw@sisk.pl>
References: <GtY7d2eWpoK.A.ioC.MQcGKB@chimera>
	<WCcYF-TAbJC.A.VXD.iQcGKB@chimera>
	<349066.43765.qm@web32603.mail.mud.yahoo.com>
	<200905260104.04844.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 May 2009 01:04:04 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Monday 25 May 2009, Martin Knoblauch wrote:
> > 
> > ----- Original Message ----
> > 
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> > > Cc: Kernel Testers List <kernel-testers@vger.kernel.org>; Martin Knoblauch <spamtrap@knobisoft.de>
> > > Sent: Sunday, May 24, 2009 9:31:18 PM
> > > Subject: [Bug #13178] Booting very slow
> > > 
> > > This message has been generated automatically as a part of a report
> > > of regressions introduced between 2.6.28 and 2.6.29.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> > > be listed and let me know (either way).
> > > 
> > > 
> > > Bug-Entry    : http://bugzilla.kernel.org/show_bug.cgi?id=13178
> > > Subject        : Booting very slow
> > > Submitter    : Martin Knoblauch 
> > > Date        : 2009-04-24 12:45 (31 days old)
> > > References    : http://marc.info/?l=linux-kernel&m=124057716231773&w=4
> > 
> >  Still happens with 2.6.30-rc7. But see my comment on bz. I would be willing to leave this as "fuzzy timing related problem.
> 
> OK
> 
> I've closed it as "unreproducible".
> 

afacit this should remain open.  It's a reproducible regression on one
of Martin's machines and it has been bisected down to a particular
commit which quite clearly has the potential to increase device
intialisation times by a lot.  Especially if that commit was buggy.
