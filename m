Return-Path: <linux-kernel-owner+w=401wt.eu-S1761226AbYCCVEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761226AbYCCVEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760476AbYCCVEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:04:31 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:58723 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760409AbYCCVEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:04:30 -0500
Date: Mon, 3 Mar 2008 22:03:10 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Pavel Machek <pavel@ucw.cz>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Adam Belay <abelay@novell.com>, linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Lee Revell <rlrevell@joe-job.com>
Subject: Re: [PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080303220310.0cab7213@mjolnir.drzeus.cx>
In-Reply-To: <20080303204603.GA19775@elf.ucw.cz>
References: <20080229193812.31f45b0c@mjolnir.drzeus.cx>
	<20080303211842.6f492782@mjolnir.drzeus.cx>
	<20080303204603.GA19775@elf.ucw.cz>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008 21:46:03 +0100
Pavel Machek <pavel@ucw.cz> wrote:

> >  
> > +static unsigned int min_deep_sleep = 2000;
> > +
> 
> Well, why not, but I believe we should default to old behaviour... not
> all machines are cheaply-build.

One would hope. ;)

But the problem is that most people will not be able to find this
option (or even know such an option exists). I'd guess the distros will
just end up having this on by default anyway. And since I could not
measure any extra power drain, I believe it's hard to justify having it
off by default (more than by pure principle).

(Then there's also the whole "But Windows doesn't have this problem!"
line of reasoning...)

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
