Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbYIWNu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbYIWNu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbYIWNr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:47:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40054 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863AbYIWNrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:47:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Bug #11543] kernel panic: softlockup in tick_periodic() ???
Date: Tue, 23 Sep 2008 15:52:40 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Joshua Hoblitt <j_kernel@hoblitt.com>
References: <PJz8fNrJNHG.A.65F.wzq1IB@albercik> <7lIhZC4hCxE.A.zJH.p0q1IB@albercik> <alpine.LFD.1.10.0809231244190.3247@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0809231244190.3247@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809231552.41464.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 23 of September 2008, Thomas Gleixner wrote:
> On Sun, 21 Sep 2008, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11543
> > Subject		: kernel panic: softlockup in tick_periodic() ???
> 
> The softlockup issue itself is fixed, but there are issues with
> nmi_watchdog. I think we should remove the regression and keep the bug
> alive to chase the other issues.

Well, for the sake of documentation I'd prefer to close this bug and create a
new non-regression one for the other issues if that's not a problem.

Thanks,
Rafael
