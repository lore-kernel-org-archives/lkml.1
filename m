Return-Path: <linux-kernel-owner+w=401wt.eu-S1757918AbYD2KbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918AbYD2KbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 06:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754292AbYD2Kap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 06:30:45 -0400
Received: from rekin18.go2.pl ([193.17.41.40]:56841 "EHLO rekin18.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195AbYD2Kao convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 06:30:44 -0400
Subject: =?UTF-8?Q?Re:_Re:_Fwd:_[PATCH]_[MMC]_fix_clock_problem_in_PXA255/270?=
From: =?UTF-8?Q?Tadeusz_Gozdek?= <linux_fan@o2.pl>
To: =?UTF-8?Q?_Pierre__Ossman?= <drzeus-list@drzeus.cx>
Cc: linux-kernel@vger.kernel.org, marcel@holtmann.org
In-Reply-To: <20080429113946.1ba93ef5@mjolnir.drzeus.cx>
References: <441f2104.26c7abf7.48157da1.e45c7@o2.pl> <20080428152859.05efccf7@mjolnir.drzeus.cx>
	<61fb248d.11640040.4816c4ed.cc@o2.pl> <20080429113946.1ba93ef5@mjolnir.drzeus.cx>
Mime-Version: 1.0
Message-ID: <60c632a5.15d4db9c.4816f8d4.b398b@o2.pl>
Date: Tue, 29 Apr 2008 12:30:44 +0200
X-Originator: 62.225.75.172
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK probably I didn't understand your policy. I ever thought that the host controller should know, when the clock should be off.
The PXA controller is different and it was the simples (but effective) way to solve this difference.

So, I hope it will be usable for people which has problem with "always on" clock, until you solve it in different way (if you going to do this).

Thanks 
Tadeusz

> That is a policy with possible side-effects (i.e. needs to be
> configurable), and host independent so it should be in the core. So I'm
> afraid I have to NAK your patch.
> 
> As a side-note, the PXA driver shouldn't be fiddling with the clock the
> way it does right now in the first place, but I have no maintainer to
> yell at. Patches removing that behaviour are very welcome.

