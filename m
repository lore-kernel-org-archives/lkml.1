Return-Path: <linux-kernel-owner+w=401wt.eu-S1761417AbXHCSyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761417AbXHCSyu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 14:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbXHCSyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 14:54:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47148 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784AbXHCSyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 14:54:40 -0400
Date: Fri, 3 Aug 2007 20:54:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       akpm@linux-foundation.org, Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH] msleep() with hrtimers
Message-ID: <20070803185429.GA20580@elte.hu>
References: <15327.1186166232@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15327.1186166232@lwn.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.1.7-deb
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0478]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jonathan Corbet <corbet@lwn.net> wrote:

> Use hrtimers so that msleep() sleeps for the requested time
> 
> Current msleep() snoozes for at least two jiffies, causing msleep(1) 
> to sleep for at least 20ms on HZ=100 systems.  Using hrtimers allows 
> msleep() to sleep for something much closer to the requested time.
> 
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>

still looks good to me.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
