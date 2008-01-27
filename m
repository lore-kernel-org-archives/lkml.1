Return-Path: <linux-kernel-owner+w=401wt.eu-S1760201AbYA0MlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760201AbYA0MlA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 07:41:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757395AbYA0MhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 07:37:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33090 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757891AbYA0MhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 07:37:15 -0500
Date: Sun, 27 Jan 2008 13:37:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: X fails to start with latest Linus git
Message-ID: <20080127123702.GB21282@elte.hu>
References: <479BCE03.6070603@gmail.com> <479BD1D1.8020503@gmail.com> <20080127062703.GA23444@elte.hu> <20080127083129.c14452ca.kjwinchester@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080127083129.c14452ca.kjwinchester@gmail.com>
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


* Kevin Winchester <kjwinchester@gmail.com> wrote:

> Sure, the result of the script is at
> 
> http://personal.nbnet.nb.ca/kwin/cfs-debug-info-2008.01.27-08.13.28

it seems you've got hpet active by default:

 /sys/devices/system/clocksource/clocksource0/current_clocksource:
 hpet
 /sys/devices/system/clocksource/clocksource0/available_clocksource:
 hpet acpi_pm pit jiffies tsc

do you get a similar lockup if you use acpi_pm? You can do that either 
by disabling the HPET options in your .config, or by doing this prior 
starting up X:

  echo acpi_pm > /sys/devices/system/clocksource/clocksource0/current_clocksource

	Ingo
