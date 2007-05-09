Return-Path: <linux-kernel-owner+w=401wt.eu-S1757825AbXEIPqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825AbXEIPqE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 11:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754929AbXEIPpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 11:45:55 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:34822 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171AbXEIPpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 11:45:54 -0400
Message-ID: <4641EC7A.7060006@drzeus.cx>
Date: Wed, 09 May 2007 17:44:58 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] MMC updates
References: <4640E17E.7090909@drzeus.cx> <46416255.3060105@drzeus.cx> <4641643D.4040305@yahoo.com.au> <464169C8.9060002@drzeus.cx> <46416B9A.3020008@yahoo.com.au> <46417D97.9090108@drzeus.cx> <46419036.8090504@s5r6.in-berlin.de>
In-Reply-To: <46419036.8090504@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Sounds to me like either struct xyz_host { atomic_t removed; } would do
> the job, or that actually wider regions of mmc_host_remove() and
> mmc_detect_change() need to be serialized.
>   

AFAIK, an atomic_t doesn't guarantee any ordering, just atomicity. So an
atomic_t with a barrier would be sufficient. But barriers are mostly
voodoo that few people understand ;)

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

