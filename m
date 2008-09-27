Return-Path: <linux-kernel-owner+w=401wt.eu-S1754215AbYI0TQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbYI0TQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 15:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbYI0TQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 15:16:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39575 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358AbYI0TQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 15:16:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [Bug #11543] kernel panic: softlockup in tick periodic()
Date: Sat, 27 Sep 2008 21:21:52 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Joshua Hoblitt <j_kernel@hoblitt.com>,
       Thomas Gleixner <tglx@linutronix.de>
References: <t_PcrlC6ypI.A.tGG.G7m3IB@albercik> <V8eU91268VO.A.nJH.A8m3IB@albercik> <20080927185040.GC10186@localhost>
In-Reply-To: <20080927185040.GC10186@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809272121.53564.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 27 of September 2008, Cyrill Gorcunov wrote:
> [Rafael J. Wysocki - Sat, Sep 27, 2008 at 05:56:46PM +0200]
> | This message has been generated automatically as a part of a report
> | of recent regressions.
> | 
> | The following bug entry is on the current list of known regressions
> | from 2.6.26.  Please verify if it still should be listed and let me know
> | (either way).
> | 
> | 
> | Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11543
> | Subject		: kernel panic: softlockup in tick_periodic() ???
> | Submitter	: Joshua Hoblitt <j_kernel@hoblitt.com>
> | Date		: 2008-09-11 16:46 (17 days old)
> | References	: http://marc.info/?l=linux-kernel&m=122117786124326&w=4
> | Handled-By	: Thomas Gleixner <tglx@linutronix.de>
> | 		  Cyrill Gorcunov <gorcunov@gmail.com>
> | 		  Ingo Molnar <mingo@elte.hu>
> | 
> | 
> 
> Hi Rafael!
> 
> Well, Thomas already explained
> 
> | The softlockup issue itself is fixed, but there are issues with
> | nmi_watchdog. I think we should remove the regression and keep the bug
> | alive to chase the other issues.
> |
> | Thanks,
> |
> |        tglx
> 
> so we either have to change the topic of this bug or better
> close it and post new one nmi_watchdog related. I may do so
> but since Joshua was opening bug it would be better if he
> make such an action. How do you think? (I've asked Joshua
> for additional info but it seems he is too busy now)

I had tried to close it, but someone reopened it afterwards.

Thanks,
Rafael
