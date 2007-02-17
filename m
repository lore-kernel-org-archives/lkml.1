Return-Path: <linux-kernel-owner+w=401wt.eu-S2992881AbXBQXfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992881AbXBQXfc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 18:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992883AbXBQXfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 18:35:32 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:36146 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992881AbXBQXfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 18:35:31 -0500
Message-ID: <45D79145.7000604@drzeus.cx>
Date: Sun, 18 Feb 2007 00:35:33 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
MIME-Version: 1.0
To: Alex Dubov <oakad@yahoo.com>
CC: linux-kernel@vger.kernel.org, Pavel Machek <pavel@suse.cz>
Subject: Re: [mmc] incorrect behavior on resume
References: <77095.44448.qm@web36703.mail.mud.yahoo.com>
In-Reply-To: <77095.44448.qm@web36703.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Dubov wrote:
> And today: yet another problem with mmc.
> It so happens that after resume mmc layer issues requests to the device before mmc_resume_host is
> called at all. Moreover, this prevents the machine from resuming, unless worked around, because
> software timer does not work at this stage of the resume and interrupts may not be delivered (if
> card was removed, for example).

Now this sounds incredibly broken. A child device should never be resumed before
its parent. Pavel, can you comment?

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
