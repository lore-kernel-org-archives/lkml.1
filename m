Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbZG0VJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbZG0VJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 17:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754833AbZG0VJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 17:09:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36493 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754832AbZG0VJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 17:09:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Bug 13306] hibernate slow on _second_ run
Date: Mon, 27 Jul 2009 23:09:49 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       bugzilla-daemon@bugzilla.kernel.org
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera> <H5-1lZIIeYK.A.hw.MZObKB@chimera> <1248682592.19945.26.camel@johannes.local>
In-Reply-To: <1248682592.19945.26.camel@johannes.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907272309.49762.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 July 2009, Johannes Berg wrote:
> On Sun, 2009-07-26 at 22:45 +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.29 and 2.6.30.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> > be listed and let me know (either way).
> 
> The problem persists in 31-rc3.

Thanks for the update.

Unfortunately, I have no idea about what's wrong here.

Generally, there are three possible areas the problem may be related to:
(1) interrupts,
(2) CPU hotplug,
(3) ordering of the platform callbacks,

but I can't say much more than that.
