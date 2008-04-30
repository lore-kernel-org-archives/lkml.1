Return-Path: <linux-kernel-owner+w=401wt.eu-S1765663AbYD3VUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765663AbYD3VUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759419AbYD3VUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:20:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54269 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759308AbYD3VUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:20:46 -0400
Date: Wed, 30 Apr 2008 23:20:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>, Jan Engelhardt <jengelh@gmx.de>,
       Richard Purdie <rpurdie@rpsys.net>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch, -git] input: CONFIG_INPUT_APANEL build fix
Message-ID: <20080430212029.GA28813@elte.hu>
References: <20080430185345.GA27224@elte.hu> <20080430150021.ZZRA012@mailhub.coreip.homeip.net> <20080430202013.GB14164@elte.hu> <20080430163924.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430163924.ZZRA012@mailhub.coreip.homeip.net>
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

> I thought the many years old rule for Linux kernel is to fix the 
> issues properly and not turn kernel into patchwork of crappy code.

correct, except if that would mean breakage for users.

> If we want to fix the randconfi issue I'd rather revert commit 
> 66242f7ec531953fbc2f4040c5ffe1f1ffe6c5c9 for now (they only thing it 
> did was beautify menuconfig look) and wait for Kconfig to be fixed. It 
> is not driver's task to track through all dependencies.

yep ... just dont export our internal crappiness to testers and users.

i'm not suggesting this is your fault in any way - but nevertheless many 
other subsystems have to deal with the same Kconfig issues and they 
manage to limp along.

	Ingo
