Return-Path: <linux-kernel-owner+w=401wt.eu-S934083AbXC2Smi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934083AbXC2Smi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 14:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934307AbXC2Smi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 14:42:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51512 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934083AbXC2Smh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 14:42:37 -0400
Date: Thu, 29 Mar 2007 20:38:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mariusz =?utf-8?Q?Koz=C5=82owski?= <m.kozlowski@tuxland.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, Matt Mackall <mpm@selenic.com>
Subject: Re: 2.6.21-rc5-mm1
Message-ID: <20070329183857.GA13362@elte.hu>
References: <20070326205706.a750bb35.akpm@linux-foundation.org> <200703292001.41255.m.kozlowski@tuxland.pl> <20070329105233.31adb052.akpm@linux-foundation.org> <200703292045.13140.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200703292045.13140.m.kozlowski@tuxland.pl>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mariusz Kozłowski <m.kozlowski@tuxland.pl> wrote:

> > > This is verified and repeatable _every_ single time I tried. 
> > > Unfortunately the last thing seen on the screen before system is 
> > > frozen is 'eth0: link down'. So my guess is that when hunting for 
> > > hangs I found something else that can hang my laptop (netconsole 
> > > that is).
> > 
> > fix-sysfs-reclaim-crash.patch is known-bad.  Did you try reverting 
> > that?
> 
> Yes, just tested it. Sorry. It doesn't change anything.

could you try a !CONFIG_SMP kernel to make sure it's not some 
self-locking of netconsole that is interfering? (Is it perhaps the 
'eth0: link down' message that is trigger from within netconsole?)

	Ingo
