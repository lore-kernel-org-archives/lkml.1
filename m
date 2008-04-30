Return-Path: <linux-kernel-owner+w=401wt.eu-S1762925AbYD3VNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762925AbYD3VNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756231AbYD3VNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:13:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40319 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755690AbYD3VNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:13:32 -0400
Date: Wed, 30 Apr 2008 23:13:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] input: JOYSTICK_XPAD build fix
Message-ID: <20080430211317.GA24633@elte.hu>
References: <20080430200340.GA13757@elte.hu> <20080430170125.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430170125.ZZRA012@mailhub.coreip.homeip.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> > which triggers with the following config:
> > 
> >  http://redhat.com/~mingo/misc/config-Wed_Apr_30_21_43_17_CEST_2008.bad
> > 
> > the reason is dependency on NEW_LEDS that was not spelled out in the 
> > Kconfig entry of JOYSTICK_XPAD.
> 
> Xpad can be compiled without LED support so this dependancy is 
> incorrect. JOYSTICK_XPAD_LEDS has proper dependancy on LEDS_CLASS, the 
> rest is Kconfig breakage.

no, you are wrong, read the current Kconfig rules again. If the user can 
create a .config that does not build, it is driver breakage. It always 
was, and has been in the past 15 years.

Kconfig might be extended to make dependencies easier to manage for 
developers but until that is implemented you have to craft your driver's 
dependencies with the current tools in a way that doesnt break the 
build.

	Ingo
