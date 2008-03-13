Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbYCMRuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbYCMRuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 13:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbYCMRt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 13:49:58 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:36611 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469AbYCMRt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 13:49:57 -0400
Date: Thu, 13 Mar 2008 18:49:38 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Len Brown <lenb@kernel.org>
Cc: linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>,
       LKML <linux-kernel@vger.kernel.org>, Adam Belay <abelay@novell.com>,
       Andi Kleen <andi@firstfloor.org>, Lee Revell <rlrevell@joe-job.com>
Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080313184938.7e27acf8@mjolnir.drzeus.cx>
In-Reply-To: <20080313173437.5f00f70e@mjolnir.drzeus.cx>
References: <Pine.LNX.4.44L0.0803031804330.8280-100000@iolanthe.rowland.org>
	<20080310100008.GA9520@elf.ucw.cz>
	<20080310134915.45ae7446@mjolnir.drzeus.cx>
	<200803121511.17389.lenb@kernel.org>
	<20080313173437.5f00f70e@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 17:34:37 +0100
Pierre Ossman <drzeus-list@drzeus.cx> wrote:

> 
> It does not. But my C3 desc looks like this:
> 
> state3/desc:ACPI FFH INTEL MWAIT 0x50
> 
> What's the meaning of the last number?
> 

I've surfed Intel's web site for a bit, and found the MWAIT instruction in the arch docs. Unfortunately, it does not explain the value 0x50. According to the docs, that would be C6, which is not listed in the regular set of states for the Core 2. I did find this however:

http://www.trustedreviews.com/cpu-memory/review/2007/03/30/Intel-Processor-Roadmap-Penryn-Nehalem-and-the-Future/p2

It says that C6 is some ultra low power mode where more or less the entire chip is powered down.

Len, Venkatesh, do you have some insight? And is it harmless to move to more power hungry modes (i.e. C4 or C3).

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
