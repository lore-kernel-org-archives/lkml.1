Return-Path: <linux-kernel-owner+w=401wt.eu-S1756609AbZKRAdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609AbZKRAdF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 19:33:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756380AbZKRAdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 19:33:04 -0500
Received: from relay.ptn-ipout02.plus.net ([212.159.7.36]:4975 "EHLO
	relay.ptn-ipout02.plus.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755583AbZKRAdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 19:33:03 -0500
X-Greylist: delayed 623 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Nov 2009 19:33:03 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoqAG/NAkvUnw4R/2dsb2JhbACBUIM8jGyzSgKIGohyCoQxBA
Subject: Re: [PATCH] hx4700: fix hx4700 touchscreen pressure values
From: "Paul Parsons" <lost.distance@yahoo.com>
To: <pavel@ucw.cz>
Cc: <rpurdie@rpsys.net>, <lenz@cs.wisc.edu>, <linux-kernel@vger.kernel.org>,
       <Dirk@Opfer-Online.de>, <arminlitzel@web.de>, <metan@ucw.cz>,
       <thommycheck@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
       <dbaryshkov@gmail.com>, <omegamoon@gmail.com>, <eric.y.miao@gmail.com>,
       <utx@penguin.cz>
Date: Wed, 18 Nov 2009 00:22:41 +0000
Content-Type: text/plain
Mime-Version: 1.0
X-Mailer: email v2.5.0 (Linux 2.6.31 x86_64 [http://email.cleancode.org])
Message-Id: <E1NAYJo-00016g-PW@pih-relay04.plus.net>
X-Plusnet-Relay: 377d33a99f7adb9678f0ed6d37deee2d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Does pressure actually work as expected -- that is not inverted?
> Because I need this patch on spitz...  but it may break your
> machine...

You are right, the pressure values were being inverted on my hx4700.
Pressing hard generates somewhat lower Rt values than pressing lightly.

Since typical hx4700 Rt values are close to (pressure_max/2) anyway,
the inverted and non-inverted values were not very different.
For example:

Rt      ts->pressure_max-Rt
599     425
562     462
588     436
570     454

So by all means submit your ads7846.c patch; it will not break hx4700.

