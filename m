Return-Path: <linux-kernel-owner+w=401wt.eu-S1760243AbXF2JQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760243AbXF2JQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 05:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755021AbXF2JQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 05:16:03 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:55483 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064AbXF2JQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 05:16:01 -0400
Message-ID: <4684CDCC.9030202@drzeus.cx>
Date: Fri, 29 Jun 2007 11:15:56 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Midhun Agnihotram <agnimidhun@gmail.com>
CC: "=?ISO-8859-1?Q?Hans-J=FCrgen_Koch?=" <hjk@linutronix.de>, jdi@l4x.org,
       linux-kernel@vger.kernel.org
Subject: Re: Fwd: Mounting MMC card
References: <4dde4acb0706261146s5906d8f3vb787d5aecb429116@mail.gmail.com>	 <200706282210.23770.hjk@linutronix.de>	 <4dde4acb0706290040p4f90b0b5q630b8e0bd5982908@mail.gmail.com>	 <200706291038.58358.hjk@linutronix.de> <4dde4acb0706290209n40d5e0adve6a3713513a6a724@mail.gmail.com>
In-Reply-To: <4dde4acb0706290209n40d5e0adve6a3713513a6a724@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Midhun Agnihotram wrote:
> 
>     The kernel version is 2.6.16. So I guess there should not be a
> problem. Any more things that I need to check??
> 

Let's try something a lot less complex than mounting. Try running:
	dd if=/dev/mmcblk0 of=/dev/null count=100

If that fails, then you should either have some revealing output in dmesg or
your device nodes must be wrong somehow.

If it succeeds, then there is some problem reading the filesystem off the card.
Have you tried mounting the card in some other system?

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
