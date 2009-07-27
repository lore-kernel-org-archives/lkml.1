Return-Path: <linux-kernel-owner+w=401wt.eu-S1755734AbZG0CNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734AbZG0CNt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 22:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755704AbZG0CNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 22:13:48 -0400
Received: from rtr.ca ([76.10.145.34]:50445 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140AbZG0CNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 22:13:47 -0400
Message-ID: <4A6D0D5B.2000607@rtr.ca>
Date: Sun, 26 Jul 2009 22:13:47 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [Bug #13839] xc5000 no longer works with Myth-0.21-fixes branch
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <3zAHs5O6maO.A.Y0B.HHObKB@chimera>
In-Reply-To: <3zAHs5O6maO.A.Y0B.HHObKB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13839
> Subject		: xc5000 no longer works with Myth-0.21-fixes branch
> Submitter	: Mark Lord <lkml@rtr.ca>
> Date		: 2009-07-19 15:15 (8 days old)
> References	: http://marc.info/?l=linux-kernel&m=124814394016848&w=4
> Handled-By	: Devin Heitmueller <dheitmueller@kernellabs.com>
..

There is definitely a regression, in that it doesn't work without
config changes to Myth.  This is due to the new way that firmware uploads
are implemented in xc5000:  slower, and more often than before.

But the MythTV workaround required is simple:

> 3. In mythtv-setup -> CaptureCards -> DVB:1 -> RecordingOptions
> there is a tickbox for "Open DVB Card on Demand".  It was ticked,
> so I un-ticked that box.  Everything now works!
> 
> When that tickbox was selected, the xc5000 took five (5) seconds to "open",
> as it did the firmware upload every time.  This appeared to exceed some
> timeout inside myth.
> 
> With the tickbox NOT ticked, myth just opens the tuner once at startup,
> and keeps it open, so no more delay when it wants to use it. 


Dunno what to say about this one.

Cheers
