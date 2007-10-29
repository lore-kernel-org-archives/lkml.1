Return-Path: <linux-kernel-owner+w=401wt.eu-S1754274AbXJ2UUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbXJ2UUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 16:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbXJ2UUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 16:20:08 -0400
Received: from ip-svs-1.Informatik.Uni-Oldenburg.DE ([134.106.12.126]:32805
	"EHLO schlidder.svs.informatik.uni-oldenburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752760AbXJ2UUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 16:20:04 -0400
Date: Mon, 29 Oct 2007 21:19:55 +0100
From: Philipp Matthias Hahn <pmhahn@titan.lahn.de>
To: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org
Cc: Pavel Machek <pavel@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [2.6.23] IBM X41 looses time after Suspend2Disk
Message-ID: <20071029201955.GA1955@titan.lahn.de>
Mail-Followup-To: Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@suse.cz>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Thomas Gleixner <tglx@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: UUCP-Freunde Lahn e.V.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas, Pavel, Rafael!

I have an IBM X41 tablet pc running 2.6.23 with the following problem:
Suspend2Ram work fine, but when I do a Suspend2Disk (echo disk >
/sys/power/state), the notebook hangs showing the following lines:
        Stopping tasks ... done.
        Shrinking memory... done (49361 pages freed)
        Freed 197444 kbytes in 0.64 seconds (308.50 MB/s)
        Suspending console(s)

When I repeatedly press some keys or move the TrackPoint, the SwSusp
continues and the notebook powers off.
On reboot, the notebook resumes but hangs showing the following screen:
        Stopping tasks ... done.
        Loading image data pages (62483 pages) ... done
        Read 249932 kbytes in 18.63 seconds (13.41 MB/s)
        Suspending console(s)

Generating interrupts by pressing keys or moving the TrackPoints makes
the resume continue. But after that, the notebook looses time, xterms
don't get updated until I press a key, the beeper beeps until I press a
key, etc.

Any idea what the problem might be?

DMESG: http://corellon.svs.informatik.uni-oldenburg.de/~pmhahn/x41.dmesg
CONFIG: http://corellon.svs.informatik.uni-oldenburg.de/~pmhahn/x41.config

If you need more data, just ask.

Thank you, BYtE
Philipp
-- 
  / /  (_)__  __ ____  __ Philipp Hahn
 / /__/ / _ \/ // /\ \/ /
/____/_/_//_/\_,_/ /_/\_\ pmhahn@titan.lahn.de
