Return-Path: <linux-kernel-owner+w=401wt.eu-S1756385AbYD2JkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385AbYD2JkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 05:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbYD2JkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 05:40:12 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:55655 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbYD2JkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 05:40:11 -0400
Date: Tue, 29 Apr 2008 11:39:46 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Tadeusz Gozdek <linux_fan@o2.pl>
Cc: linux-kernel@vger.kernel.org, marcel@holtmann.org
Subject: Re: Fwd: [PATCH] [MMC] fix clock problem in PXA255/270
Message-ID: <20080429113946.1ba93ef5@mjolnir.drzeus.cx>
In-Reply-To: <61fb248d.11640040.4816c4ed.cc@o2.pl>
References: <441f2104.26c7abf7.48157da1.e45c7@o2.pl>
	<20080428152859.05efccf7@mjolnir.drzeus.cx>
	<61fb248d.11640040.4816c4ed.cc@o2.pl>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 08:49:17 +0200
Tadeusz Gozdek <linux_fan@o2.pl> wrote:

> Hi
> As you can check, after finishing all operations clock is leaved as switched on (its switched off and on again during sending next command e.g. GO_INACTIVE_STATE). The same is after wake-up the system, even if the clock was switched off. 
> Switched on clock has sometimes an influence on the rest of the hardware e.g. the GPS modules and on battery life in a battery powered systems.
> 

That is a policy with possible side-effects (i.e. needs to be
configurable), and host independent so it should be in the core. So I'm
afraid I have to NAK your patch.

As a side-note, the PXA driver shouldn't be fiddling with the clock the
way it does right now in the first place, but I have no maintainer to
yell at. Patches removing that behaviour are very welcome.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
