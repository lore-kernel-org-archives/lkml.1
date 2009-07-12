Return-Path: <linux-kernel-owner+w=401wt.eu-S1751968AbZGLUTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbZGLUTz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 16:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbZGLUTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 16:19:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59766 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbZGLUTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 16:19:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Celejar <celejar@gmail.com>
Subject: Re: suspend to disk now broken
Date: Sun, 12 Jul 2009 22:19:52 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc2-rjw; KDE/4.2.4; x86_64; ; )
Cc: lkml <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <20090712151947.25446ceb.celejar@gmail.com>
In-Reply-To: <20090712151947.25446ceb.celejar@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907122219.53116.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 July 2009, Celejar wrote:
> Hi,
> 
> A recent change to the kernel has apparently broken suspend to disk on
> my machine.  It still works fine in 2.6.30.1, but hangs during the
> 'devices' phase of suspension with 2.6.31-rc2.  [I originally saw the
> problem using the wireless-testing git repo, but I've subsequently
> reproduced it using the mainline code from the kernel.org homepage.]  I
> saw a rumor that the problem may have something to do with recent
> changes to the Intel graphics drivers, so  I've tried to remove the
> driver (i915) before suspending, but it won't come out.
> 
> The machine is an Acer Aspire 3690 laptop, with Intel motherboard and
> chipsets and Broadcom networking.  The last message seen on the console
> during the failed suspend is:
> 
> Suspending console(s) (use no_console_suspend to debug)
> 
> The machine has no serial port, but I do have a Prolific USB-serial
> converter; will that be useful?
> 
> I'm attaching the output of 'grep ^C .config', since I assume that it
> contains relevant information.
> 
> Please cc. me on responses.

Do you use s2disk or 'echo disk > /sys/power/state'?

Rafael
