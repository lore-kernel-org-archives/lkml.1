Return-Path: <linux-kernel-owner+w=401wt.eu-S1762399AbYCEGGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762399AbYCEGGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 01:06:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756410AbYCEGGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 01:06:21 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:47316 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755716AbYCEGGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 01:06:20 -0500
Date: Wed, 5 Mar 2008 07:04:54 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@codemonkey.org.uk>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, Adam Belay <abelay@novell.com>,
       Lee Revell <rlrevell@joe-job.com>, linux-pm@lists.linux-foundation.org,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080305070454.3df78593@mjolnir.drzeus.cx>
In-Reply-To: <20080304183406.GC27332@one.firstfloor.org>
References: <924EFEDD5F540B4284297C4DC59F3DEEA2E8B2@orsmsx423.amr.corp.intel.com>
	<Pine.LNX.4.44L0.0803031804330.8280-100000@iolanthe.rowland.org>
	<20080303231033.GB15255@one.firstfloor.org>
	<20080304040048.GA31562@codemonkey.org.uk>
	<20080304071423.0e6b71c1@mjolnir.drzeus.cx>
	<20080304181924.70aaf8c1@mjolnir.drzeus.cx>
	<20080304172918.GA27332@one.firstfloor.org>
	<20080304183032.17084e39@mjolnir.drzeus.cx>
	<20080304174315.GB27332@one.firstfloor.org>
	<20080304190446.775165e3@mjolnir.drzeus.cx>
	<20080304183406.GC27332@one.firstfloor.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008 19:34:06 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> On Tue, Mar 04, 2008 at 07:04:46PM +0100, Pierre Ossman wrote:
> > 
> > I don't think I quite see the point. If we can't force an update, then
> > it doesn't really help us knowing if the jiffies value is stale or not.
> 
> What do you mean with force an update? The system always does an 
> jiffies update automatically after idle wakeup. It's just that if you add 
> code to the code path that uses jiffies you have to make sure it is after the 
> standard update, otherwise you'll see a stale value.
> 

I still don't follow. Perhaps you can express it in pseudo code? If I have a stale value that I cannot refresh, knowing that it is stale doesn't change anything.


-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
