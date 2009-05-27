Return-Path: <linux-kernel-owner+w=401wt.eu-S1761440AbZE0TsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761440AbZE0TsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 15:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758882AbZE0TsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 15:48:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56223 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757482AbZE0TsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 15:48:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug #13178] Booting very slow
Date: Wed, 27 May 2009 21:48:28 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Martin Knoblauch <spamtrap@knobisoft.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <GtY7d2eWpoK.A.ioC.MQcGKB@chimera> <200905260104.04844.rjw@sisk.pl> <20090526233244.b817948e.akpm@linux-foundation.org>
In-Reply-To: <20090526233244.b817948e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905272148.29524.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 May 2009, Andrew Morton wrote:
> On Tue, 26 May 2009 01:04:04 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Monday 25 May 2009, Martin Knoblauch wrote:
> > > 
> > > ----- Original Message ----
> > > 
> > > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > > To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> > > > Cc: Kernel Testers List <kernel-testers@vger.kernel.org>; Martin Knoblauch <spamtrap@knobisoft.de>
> > > > Sent: Sunday, May 24, 2009 9:31:18 PM
> > > > Subject: [Bug #13178] Booting very slow
> > > > 
> > > > This message has been generated automatically as a part of a report
> > > > of regressions introduced between 2.6.28 and 2.6.29.
> > > > 
> > > > The following bug entry is on the current list of known regressions
> > > > introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> > > > be listed and let me know (either way).
> > > > 
> > > > 
> > > > Bug-Entry    : http://bugzilla.kernel.org/show_bug.cgi?id=13178
> > > > Subject        : Booting very slow
> > > > Submitter    : Martin Knoblauch 
> > > > Date        : 2009-04-24 12:45 (31 days old)
> > > > References    : http://marc.info/?l=linux-kernel&m=124057716231773&w=4
> > > 
> > >  Still happens with 2.6.30-rc7. But see my comment on bz. I would be willing to leave this as "fuzzy timing related problem.
> > 
> > OK
> > 
> > I've closed it as "unreproducible".
> > 
> 
> afacit this should remain open.  It's a reproducible regression on one
> of Martin's machines and it has been bisected down to a particular
> commit which quite clearly has the potential to increase device
> intialisation times by a lot.  Especially if that commit was buggy.

OK, reopened.
