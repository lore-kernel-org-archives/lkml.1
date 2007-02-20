Return-Path: <linux-kernel-owner+w=401wt.eu-S964800AbXBTHDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964800AbXBTHDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 02:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964802AbXBTHDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 02:03:17 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:59933 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964800AbXBTHDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 02:03:17 -0500
Message-ID: <45DA9D3B.5030007@drzeus.cx>
Date: Tue, 20 Feb 2007 08:03:23 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
MIME-Version: 1.0
To: Alex Dubov <oakad@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Recent and not-so problems with tifm_sd driver
References: <320344.9830.qm@web36715.mail.mud.yahoo.com>
In-Reply-To: <320344.9830.qm@web36715.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Dubov wrote:
> 
> correction: my driver schedules (wakes kthread in 0.7) mmc_remove_host - noticed it only now
> 

Ok, good. Then things are as they should on your part.

> 
> That's why I think that simply flushing the workqueue is enough. If workqueue is empty we know for
> sure that device_add has exited.
> 

>From -mm:

http://www.kernel.org/git/?p=linux/kernel/git/drzeus/mmc.git;a=commitdiff;h=e89bac488861ebadfca3a74321af19a262dcbd08

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
