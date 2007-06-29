Return-Path: <linux-kernel-owner+w=401wt.eu-S1761199AbXF2K3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761199AbXF2K3w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 06:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756415AbXF2K3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 06:29:45 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:49627 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755534AbXF2K3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 06:29:44 -0400
Message-ID: <4684DF17.2040804@drzeus.cx>
Date: Fri, 29 Jun 2007 12:29:43 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Uli Luckas <u.luckas@road.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       Midhun Agnihotram <agnimidhun@gmail.com>,
       "=?ISO-8859-1?Q?Hans-J=FCrgen_Koch?=" <hjk@linutronix.de>, jdi@l4x.org
Subject: Re: Fwd: Mounting MMC card
References: <4dde4acb0706261146s5906d8f3vb787d5aecb429116@mail.gmail.com> <4684CDCC.9030202@drzeus.cx> <4dde4acb0706290230g6a38f0cds47b0d76216f861e6@mail.gmail.com> <200706291142.50893.u.luckas@road.de>
In-Reply-To: <200706291142.50893.u.luckas@road.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Uli Luckas wrote:
> If I remember correctly, mmc devices did not have fixed majors/minors 
> allocated until recently. Either get a recent kernel or use some kind of 
> hotplug (udev) scripts to create your device nodes with dynamically allocated 
> major/minors.
> 

Correct. But a double check in /proc/devices reveals the current allocation.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
