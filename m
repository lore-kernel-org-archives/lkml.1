Return-Path: <linux-kernel-owner+w=401wt.eu-S1759921AbYD2QWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759921AbYD2QWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 12:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbYD2QWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 12:22:36 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:57767 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257AbYD2QWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 12:22:35 -0400
Date: Tue, 29 Apr 2008 18:22:08 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Tadeusz Gozdek <linux_fan@o2.pl>
Cc: linux-kernel@vger.kernel.org, marcel@holtmann.org
Subject: Re: Fwd: [PATCH] [MMC] fix clock problem in PXA255/270
Message-ID: <20080429182208.70e1053e@mjolnir.drzeus.cx>
In-Reply-To: <60c632a5.15d4db9c.4816f8d4.b398b@o2.pl>
References: <441f2104.26c7abf7.48157da1.e45c7@o2.pl>
	<20080428152859.05efccf7@mjolnir.drzeus.cx>
	<61fb248d.11640040.4816c4ed.cc@o2.pl>
	<20080429113946.1ba93ef5@mjolnir.drzeus.cx>
	<60c632a5.15d4db9c.4816f8d4.b398b@o2.pl>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 12:30:44 +0200
Tadeusz Gozdek <linux_fan@o2.pl> wrote:

> OK probably I didn't understand your policy. I ever thought that the host controller should know, when the clock should be off.

No, it's not because it's not my policy, but because the kernel tries
to avoid handling "policy". :)

It is common to talk about software that implements "policy" or
"mechanism". "mechanism" is simple the act of performing a given, well
defined task (e.g. turn on LED A). "policy" on the other hand is
selecting an action when there are multiple, equally valid actions.
Usually this involves the user, directly or indirectly.

The kernel tries to stay clear of "policy" as it is a complex problem
that is better solved per system, in user space. So what I meant when I
said that this is policy, I was saying that this is a "policy" kind of
decision that needs to be configurable from user space.

> The PXA controller is different and it was the simples (but effective) way to solve this difference.

Different in what regard? Or are you referring to the already present
clock fudging in the driver?

> 
> So, I hope it will be usable for people which has problem with "always on" clock, until you solve it in different way (if you going to do this).
> 

This is a project that has been popping up now and then, but the big
thing that is lacking is someone who is able to actually measure if
there is a power gain from this. I don't want to add a lot of code that
isn't doing any good, so I want hard numbers.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
