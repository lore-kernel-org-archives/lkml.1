Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbYCMRoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbYCMRoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 13:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbYCMRoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 13:44:32 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:52303 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086AbYCMRob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 13:44:31 -0400
Date: Thu, 13 Mar 2008 18:44:12 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: "Len Brown" <lenb@kernel.org>, linux-pm@lists.linux-foundation.org,
       "Pavel Machek" <pavel@ucw.cz>, "LKML" <linux-kernel@vger.kernel.org>,
       "Adam Belay" <abelay@novell.com>, "Andi Kleen" <andi@firstfloor.org>,
       "Lee Revell" <rlrevell@joe-job.com>
Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080313184412.34d09870@mjolnir.drzeus.cx>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEEB33CDD@orsmsx423.amr.corp.intel.com>
References: <Pine.LNX.4.44L0.0803031804330.8280-100000@iolanthe.rowland.org>
	<20080310100008.GA9520@elf.ucw.cz>
	<20080310134915.45ae7446@mjolnir.drzeus.cx>
	<200803121511.17389.lenb@kernel.org>
	<20080313173437.5f00f70e@mjolnir.drzeus.cx>
	<924EFEDD5F540B4284297C4DC59F3DEEB33CDD@orsmsx423.amr.corp.intel.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 09:47:30 -0700
"Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com> wrote:

> 
> Can you try using /dev/cpu_dma_latency from an user space application.
> Refer Documentation/pm_qos_interface.txt for usage. With this interface
> you can change menu governor behavior from userspace, by dynamically
> allowing it to use C3 or not. I am thinking that something like allowing
> C3 for few seconds and blocking it for few seconds may help.
> 

I don't quite follow. Is the theory that you get a window of a few seconds where the system stops making a noise, even as it toggles C3?

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
