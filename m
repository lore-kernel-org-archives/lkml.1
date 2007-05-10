Return-Path: <linux-kernel-owner+w=401wt.eu-S1757380AbXEJFpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380AbXEJFpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 01:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754235AbXEJFox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 01:44:53 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:50036 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753682AbXEJFow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 01:44:52 -0400
Message-ID: <4642B122.5070609@drzeus.cx>
Date: Thu, 10 May 2007 07:44:02 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] MMC updates
References: <46375B18.4080802@drzeus.cx> <20070509185636.GB26981@flint.arm.linux.org.uk> <46421BB5.7040504@drzeus.cx> <20070509221253.GC26981@flint.arm.linux.org.uk>
In-Reply-To: <20070509221253.GC26981@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> See the comments immediately above and below its use.
>
> Welcome to buggy hardware.
>
>   

I've read through the erratum, and to me it seems like the bug affects
all long replies, not just these codes. So I think the code should be
fixed to look at the response flag, not the opcode.

Do you have hardware so that you can test such a change?

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

