Return-Path: <linux-kernel-owner+w=401wt.eu-S1758433AbYD2GtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758433AbYD2GtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 02:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbYD2GtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 02:49:17 -0400
Received: from rekin23.go2.pl ([193.17.41.16]:56450 "EHLO rekin23.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbYD2GtR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 02:49:17 -0400
X-Greylist: delayed 83779 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Apr 2008 02:49:16 EDT
Subject: =?UTF-8?Q?Re:_Re:_Fwd:_[PATCH]_[MMC]_fix_clock_problem_in_PXA255/270?=
From: =?UTF-8?Q?Tadeusz_Gozdek?= <linux_fan@o2.pl>
To: drzeus-list@drzeus.cx
Cc: linux-kernel@vger.kernel.org, marcel@holtmann.org
In-Reply-To: <20080428152859.05efccf7@mjolnir.drzeus.cx>
References: <441f2104.26c7abf7.48157da1.e45c7@o2.pl> <20080428152859.05efccf7@mjolnir.drzeus.cx>
Mime-Version: 1.0
Message-ID: <61fb248d.11640040.4816c4ed.cc@o2.pl>
Date: Tue, 29 Apr 2008 08:49:17 +0200
X-Originator: 62.93.34.186
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
As you can check, after finishing all operations clock is leaved as switched on (its switched off and on again during sending next command e.g. GO_INACTIVE_STATE). The same is after wake-up the system, even if the clock was switched off. 
Switched on clock has sometimes an influence on the rest of the hardware e.g. the GPS modules and on battery life in a battery powered systems.

Tadeusz

> On Mon, 28 Apr 2008 09:32:49 +0200
> Tadeusz Gozdek <linux_fan@o2.pl> wrote:
> 
> > It solves the problems with clock in the PXA255/270 MMC/SD hardware.
> > This solution was testes with our devices and works good.
> > Kernel 2.6.24.4 (but should work with >=2.6.19)
> > 
> 
> What issue is this supposed to solve?
> 
> Rgds
> 
> -- 
>      -- Pierre Ossman
> 
>   Linux kernel, MMC maintainer        http://www.kernel.org
>   PulseAudio, core developer          http://pulseaudio.org
>   rdesktop, core developer          http://www.rdesktop.org
---- Wiadomość Oryginalna ----
Od: Pierre Ossman <drzeus-list@drzeus.cx>
Do: Tadeusz Gozdek <linux_fan@o2.pl>
Kopia do: linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Data: 28 kwietnia 2008 15:28
Temat: Re: Fwd: [PATCH] [MMC] fix clock problem in PXA255/270

> On Mon, 28 Apr 2008 09:32:49 +0200
> Tadeusz Gozdek <linux_fan@o2.pl> wrote:
> 
> > It solves the problems with clock in the PXA255/270 MMC/SD hardware.
> > This solution was testes with our devices and works good.
> > Kernel 2.6.24.4 (but should work with >=2.6.19)
> > 
> 
> What issue is this supposed to solve?
> 
> Rgds
> 
> -- 
>      -- Pierre Ossman
> 
>   Linux kernel, MMC maintainer        http://www.kernel.org
>   PulseAudio, core developer          http://pulseaudio.org
>   rdesktop, core developer          http://www.rdesktop.org

