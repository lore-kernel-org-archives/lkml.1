Return-Path: <linux-kernel-owner+w=401wt.eu-S1946464AbXBCOpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946464AbXBCOpY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 09:45:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946465AbXBCOpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 09:45:24 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:44142 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946464AbXBCOpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 09:45:24 -0500
Message-ID: <45C49FFA.70104@drzeus.cx>
Date: Sat, 03 Feb 2007 15:45:14 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
MIME-Version: 1.0
To: Anderson Briglia <anderson.briglia@indt.org.br>
CC: Russell King <rmk+lkml@arm.linux.org.uk>,
       "Lizardo Anderson (EXT-INdT/Manaus)" <anderson.lizardo@indt.org.br>,
       linux-kernel@vger.kernel.org,
       "Aguiar Carlos (EXT-INdT/Manaus)" <carlos.aguiar@indt.org.br>,
       Tony Lindgren <tony@atomide.com>,
       ext David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 4/4] Add MMC Password Protection (lock/unlock) support
 V9: mmc_sysfs.diff
References: <4582F007.7030100@indt.org.br> <459B9C4E.3020406@indt.org.br> <45A021B2.4090104@drzeus.cx> <45BE3E70.9050505@indt.org.br> <45BF8A28.5010605@drzeus.cx> <45BFB818.3020908@indt.org.br>
In-Reply-To: <45BFB818.3020908@indt.org.br>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anderson Briglia wrote:
> Hi Pierre,
>
> How about now? Is better?
>
>   

Locking problem is still there. You need to unclaim the host even when
claim fails.

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

