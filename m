Return-Path: <linux-kernel-owner+w=401wt.eu-S1750886AbXBJNBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750886AbXBJNBf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 08:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbXBJNBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 08:01:35 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:57320 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbXBJNBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 08:01:33 -0500
Message-ID: <45CDC22B.6040408@drzeus.cx>
Date: Sat, 10 Feb 2007 14:01:31 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
MIME-Version: 1.0
To: Alex Dubov <oakad@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Recent and not-so problems with tifm_sd driver - one more
References: <113489.35158.qm@web36703.mail.mud.yahoo.com>
In-Reply-To: <113489.35158.qm@web36703.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Dubov wrote:
> One more problem (you may already know about it) - I was contacted by somebody from the hald
> project and indeed I can confirm that on 2.6.20 kernel hald fails to take action on card
> insertion. I can't see anything in my code so this may be a general mmc problem.
> The problem is described here:
> http://lists.freedesktop.org/archives/hal/2007-January/006960.html
> 

Odd. This might be the whole sysfs restructuring thing causing problems. Can you
check if that user has CONFIG_SYSFS_DEPRECATED on?

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
