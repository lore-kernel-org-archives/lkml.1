Return-Path: <linux-kernel-owner+w=401wt.eu-S1758919AbYESMXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919AbYESMXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 08:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbYESMXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 08:23:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52558 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285AbYESMXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 08:23:34 -0400
Date: Mon, 19 May 2008 14:23:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/5] x86: Move es7000_plat out of mpparse.c
Message-ID: <20080519122322.GB6700@elte.hu>
References: <20080514150251.24443.5516.stgit@thinkpad> <20080516124319.GB16520@elte.hu> <20080516130342.GA22993@elte.hu> <20080516130422.GA24607@elte.hu> <482E1955.8080506@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482E1955.8080506@suse.de>
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


* Alexey Starikovskiy <astarikovskiy@suse.de> wrote:

> Ingo,
> I seem to have lost the track of changes... Why the ifdef LOCAL_APIC was 
> switched to MPPARSE?
>
> Reverting it back makes the error to go away...

ok - this is indeed merge damage - fixed it up in latest -tip.

	Ingo
