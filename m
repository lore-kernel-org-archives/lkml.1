Return-Path: <linux-kernel-owner+w=401wt.eu-S1764130AbXHFMIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764130AbXHFMIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 08:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763131AbXHFMID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 08:08:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55528 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763243AbXHFMIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 08:08:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Meelis Roos <mroos@linux.ee>
Subject: Re: Kconfig: 'SUSPEND_SMP' refers to undefined symbol 'HOTPLUG_CPU'
Date: Mon, 6 Aug 2007 14:17:15 +0200
User-Agent: KMail/1.9.5
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
References: <Pine.SOC.4.64.0708041425020.26419@math.ut.ee> <200708051912.17342.rjw@sisk.pl> <Pine.SOC.4.64.0708061314380.7974@math.ut.ee>
In-Reply-To: <Pine.SOC.4.64.0708061314380.7974@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708061417.15479.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 6 August 2007 12:18, Meelis Roos wrote:
> > Hmm, with this .config SUSPEND_SMP cannot be set, because SMP is unset in it.
> > 
> > Can you please check if this warning is still present with the patch from
> > http://marc.info/?l=linux-kernel&m=118633307113052&w=2 applied?
> 
> Hmm, does not apply to 2.6.23-rc2:
> 2 out of 2 hunks FAILED -- saving rejects to file kernel/power/Kconfig.rej
> 1 out of 1 hunk FAILED -- saving rejects to file arch/x86_64/Kconfig.rej
> 1 out of 1 hunk FAILED -- saving rejects to file arch/arm/Kconfig.rej
> 1 out of 1 hunk FAILED -- saving rejects to file arch/i386/Kconfig.rej
> 1 out of 1 hunk FAILED -- saving rejects to file arch/powerpc/Kconfig.rej

Hmm, strange.  It applies for me (did you get the raw message?).

> It doesn't seem to touch arch/ppc/Kconfig but only arch/powerpc/Kconfig 
> - should it make any difference at all?

No, it shouldn't, AFAICS.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
