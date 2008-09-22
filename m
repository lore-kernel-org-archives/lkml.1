Return-Path: <linux-kernel-owner+w=401wt.eu-S1752391AbYIVGCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbYIVGCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 02:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbYIVGB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 02:01:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:47076 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbYIVGB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 02:01:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=S25D5f9zZ4wqvEJEOMnW0+Mjft8fPoTEbpmaEyTNjqlT5NCu1DpwYxvAxkmO2/muuD
         plkUJjonMQ4QpGCFaQDOg2lZ042BF9Ho25M5wO9lHkMxzBnDNC86qjo16zAjQVUtGnyF
         WzYFtGZEFbPH2vx5lAUDySHLR0HwHD5S0Si6w=
Date: Mon, 22 Sep 2008 10:01:57 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Joshua Hoblitt <j_kernel@hoblitt.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Bug #11543] kernel panic: softlockup in tick_periodic() ???
Message-ID: <20080922060157.GA7663@localhost>
References: <PJz8fNrJNHG.A.65F.wzq1IB@albercik> <7lIhZC4hCxE.A.zJH.p0q1IB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7lIhZC4hCxE.A.zJH.p0q1IB@albercik>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Rafael J. Wysocki - Sun, Sep 21, 2008 at 08:54:19PM +0200]
| This message has been generated automatically as a part of a report
| of recent regressions.
| 
| The following bug entry is on the current list of known regressions
| from 2.6.26.  Please verify if it still should be listed and let me know
| (either way).
| 
| 
| Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11543
| Subject		: kernel panic: softlockup in tick_periodic() ???
| Submitter	: Joshua Hoblitt <j_kernel@hoblitt.com>
| Date		: 2008-09-11 16:46 (11 days old)
| References	: http://marc.info/?l=linux-kernel&m=122117786124326&w=4
| Handled-By	: Thomas Gleixner <tglx@linutronix.de>
| 		  Cyrill Gorcunov <gorcunov@gmail.com>
| 		  Ingo Molnar <mingo@elte.hu>
| 
| 

There are really multiple issues touched in report. nmi_watchdog
hangs, rtc device creation, NULL deref...

I've asked Joshua for more information. Since he must to use
netdev tree for a while maybe we could wait 'till next merge
window will be closed and check if nmi_watchdog does work.
So the work in progress.

		- Cyrill -
