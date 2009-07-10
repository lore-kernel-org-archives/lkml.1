Return-Path: <linux-kernel-owner+w=401wt.eu-S1751940AbZGJCK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbZGJCK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 22:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751100AbZGJCKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 22:10:45 -0400
Received: from mail.anarazel.de ([217.115.131.40]:49424 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbZGJCKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 22:10:43 -0400
From: Andres Freund <andres@anarazel.de>
To: John Dykstra <john.dykstra1@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc2: Reported regressions from 2.6.30
Date: Fri, 10 Jul 2009 04:10:37 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc2-andres-00152-g6a6dd01-dirty; KDE/4.2.95; x86_64; ; )
Cc: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera> <200907070325.51439.andres@anarazel.de> <1247190417.7306.2.camel@merlyn>
In-Reply-To: <1247190417.7306.2.camel@merlyn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200907100410.37506.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John, Hi Rafael,

On Friday 10 July 2009 03:46:57 John Dykstra wrote:
> On Tue, 2009-07-07 at 03:25 +0200, Andres Freund wrote:
> > There is also http://lkml.org/lkml/2009/6/30/398 : Soft-Lockup/Race
> > in
> > networking in 2.6.31-rc1+195 (possibly caused by netem)
>
> There is some similarity between this soft lockup and the one reported
> in http://www.spinics.net/lists/netdev/msg100957.html.  In both, the
> process is doing both sends and receives on raw sockets.
The issue turned out to be a hrtimer bug - i dont see anything like it in your 
trace. If you still want to test the fix, its 
de907e8432b08f2d5966c36e0747e97c0e596810 in -tip (or 
http://lkml.org/lkml/2009/7/9/150)

Rafael: In case youre reading this, I guess you can mark that bug as resolved.

Andres
