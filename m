Return-Path: <linux-kernel-owner+w=401wt.eu-S1758760AbYCDRcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760AbYCDRcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 12:32:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbYCDRb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 12:31:57 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:55980 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbYCDRb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 12:31:56 -0500
Date: Tue, 4 Mar 2008 18:30:32 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@codemonkey.org.uk>, Andi Kleen <andi@firstfloor.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, Adam Belay <abelay@novell.com>,
       Lee Revell <rlrevell@joe-job.com>, linux-pm@lists.linux-foundation.org,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080304183032.17084e39@mjolnir.drzeus.cx>
In-Reply-To: <20080304172918.GA27332@one.firstfloor.org>
References: <924EFEDD5F540B4284297C4DC59F3DEEA2E8B2@orsmsx423.amr.corp.intel.com>
	<Pine.LNX.4.44L0.0803031804330.8280-100000@iolanthe.rowland.org>
	<20080303231033.GB15255@one.firstfloor.org>
	<20080304040048.GA31562@codemonkey.org.uk>
	<20080304071423.0e6b71c1@mjolnir.drzeus.cx>
	<20080304181924.70aaf8c1@mjolnir.drzeus.cx>
	<20080304172918.GA27332@one.firstfloor.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008 18:29:18 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> > So for now, I'm back to thinking that measuring the interval between deep sleeps is the better approach. I could use some ideas for a good clock source though. I haven't dug much deeper than jiffies when it comes to kernel timekeeping.
> 
> jiffies should work, you just need to make sure you measure them at the
> right place. In particular there is some code in dyntick that catches
> up on jiffies after the deep sleep when the normal timer handler didn't run
> and jiffies are only usable again after that code executed.
> 

And how can I tell if this handler has run? Not that it really matters I guess, as I don't think running it from the cpuidle governor is very sane.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
