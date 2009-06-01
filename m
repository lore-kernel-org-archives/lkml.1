Return-Path: <linux-kernel-owner+w=401wt.eu-S1757959AbZFAUsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959AbZFAUsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 16:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755214AbZFAUsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 16:48:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56234 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811AbZFAUsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 16:48:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Bug #13306] hibernate slow on _second_ run
Date: Mon, 1 Jun 2009 22:48:48 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <4to6E2myxvG.A.muC.aIbIKB@chimera> <200906012226.46086.rjw@sisk.pl> <1243888860.5299.32.camel@johannes.local>
In-Reply-To: <1243888860.5299.32.camel@johannes.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906012248.49304.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 June 2009, Johannes Berg wrote:
> On Mon, 2009-06-01 at 22:26 +0200, Rafael J. Wysocki wrote:
> > On Sunday 31 May 2009, Johannes Berg wrote:
> > > On Sat, 2009-05-30 at 21:37 +0200, Rafael J. Wysocki wrote:
> > > > This message has been generated automatically as a part of a report
> > > > of recent regressions.
> > > > 
> > > > The following bug entry is on the current list of known regressions
> > > > from 2.6.29.  Please verify if it still should be listed and let me know
> > > > (either way).
> > > > 
> > > > 
> > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13306
> > > > Subject		: hibernate slow on _second_ run
> > > > Submitter	: Johannes Berg <johannes@sipsolutions.net>
> > > > Date		: 2009-05-14 09:34 (17 days old)
> > > 
> > > I'm trying to get an ftrace profile that covers the point in question,
> > > but it might take me a couple of days.
> > 
> > Did it work?
> 
> No, it's now hanging 20 seconds much later, after returning to
> userspace :( But the dmesg log still has a hang of ~20.5 seconds just
> like before, between two kernel messages...

Hmm.  Can you try to comment out suspend_device_irqs() and resume_device_irqs()
in drivers/base/power/main.c and see what happens?

Rafael
