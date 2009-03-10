Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbZCJN5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbZCJN5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 09:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754325AbZCJN5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 09:57:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44682 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112AbZCJN5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 09:57:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Eric Anholt <eric@anholt.net>
Subject: Re: [Bug #12806] i915 broken STR
Date: Tue, 10 Mar 2009 14:56:47 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc7-tst; KDE/4.2.1; x86_64; ; )
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <KiHv0irKPzE.A.l3.hUarJB@chimera> <200903072228.47358.rjw@sisk.pl> <1236651832.10190.20.camel@gaiman>
In-Reply-To: <1236651832.10190.20.camel@gaiman>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903101456.48444.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 March 2009, Eric Anholt wrote:
> On Sat, 2009-03-07 at 22:28 +0100, Rafael J. Wysocki wrote:
> > On Saturday 07 March 2009, Harvey Harrison wrote:
> > > On Tue, 2009-03-03 at 20:25 +0100, Rafael J. Wysocki wrote:
> > > > This message has been generated automatically as a part of a report
> > > > of recent regressions.
> > > > 
> > > > The following bug entry is on the current list of known regressions
> > > > from 2.6.28.  Please verify if it still should be listed and let me know
> > > > (either way).
> > > > 
> > > > 
> > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12806
> > > > Subject		: i915 broken STR
> > > > Submitter	: Harvey Harrison <harvey.harrison@gmail.com>
> > > > Date		: 2009-02-28 4:20 (4 days old)
> > > > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5669fcacc58bf3a7386057addffd280d75380858
> > > > References	: http://marc.info/?l=linux-kernel&m=123579487801064&w=4
> > > > 
> > > > 
> > > 
> > > This looks to have been a case of old-userspace..upgrading to
> > > xorg-intel-video 2.6.1 (ubuntu Jaunty Alpha5) fixes STR here.
> > 
> > Well, thanks, but I'm not really sure if this is a good news.
> > 
> > Jesse, Eric, does it mean we now break resume on anything earlier than 2.6.1
> > on the Harvey's hardware?
> 
> There's not much information (dmesg, Xorg.0.log) with this bug -- I'm
> guessing he's using KMS, given that that commit was where the problems
> started.  If so, yes, you really do need good userland for KMS to work.

BTW, Is suspend generally supposed to work with KMS and the 2.6.1 (or later) X
driver?

Rafael
