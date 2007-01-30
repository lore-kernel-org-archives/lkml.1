Return-Path: <linux-kernel-owner+w=401wt.eu-S1030183AbXA3SK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030183AbXA3SK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 13:10:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030188AbXA3SKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 13:10:55 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:57262 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030183AbXA3SKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 13:10:54 -0500
Message-ID: <45BF8A28.5010605@drzeus.cx>
Date: Tue, 30 Jan 2007 19:10:48 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20061223)
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
References: <4582F007.7030100@indt.org.br> <459B9C4E.3020406@indt.org.br> <45A021B2.4090104@drzeus.cx> <45BE3E70.9050505@indt.org.br>
In-Reply-To: <45BE3E70.9050505@indt.org.br>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anderson Briglia wrote:
> Hi Pierre,
>
> Sorry about the delay.
> I changed a bit the code to align with your latest suggestions.
>
>   

Nice, but the locking is broken again.

> I believe now the number of goto's is ok.
>
>   

Actually, the ones you have left are completely useless. So you can just
remove the last bunch aswell.

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

