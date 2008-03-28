Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842AbYC1KUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbYC1KUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 06:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbYC1KUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 06:20:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39679 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483AbYC1KUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 06:20:34 -0400
Date: Fri, 28 Mar 2008 11:20:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Brownell <david-b@pacbell.net>
Cc: Mark Lord <lkml@rtr.ca>, David Miller <davem@davemloft.net>,
       jkosina@suse.cz, gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, pavel@suse.cz, akpm@linux-foundation.org,
       rtc-linux@googlegroups.com
Subject: Re: 2.6.25-rc7: Ugh.
Message-ID: <20080328102010.GA633@elte.hu>
References: <20080327160700.GB828@suse.de> <200803272358.20081.david-b@pacbell.net> <20080328091645.GI21413@elte.hu> <200803280249.42193.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803280249.42193.david-b@pacbell.net>
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


* David Brownell <david-b@pacbell.net> wrote:

> Prevent the most significant RTC configuration problems:
> 
>  - If the new RTC framework is enabled, don't allow any of the
>    legacy drivers to be configured.

yay!!!!

>  - When using generic RTC on x86, enable rtc-cmos by default.

Amen.

> It seems too many people are used to enabling a legacy RTC despite the 
> Kconfig help/comments; the gentle approach hasn't worked.

Very-Much-Acked-by: Ingo Molnar <mingo@elte.hu>

it's not just about being gentle: it's that there are thousands of 
.config options that are confusing to most users, so our defaults and 
rules must make sense. If we think that an approach is superior (which 
your new RTC code certainly is), we have to take up the responsibility 
of pushing that as a prominent, default choice and excluding the old 
code. That ends up benefiting everyone, reduces complexity of the 
kernel. You wont see anyone shed tears for the old code.

	Ingo
