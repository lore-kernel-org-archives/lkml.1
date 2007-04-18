Return-Path: <linux-kernel-owner+w=401wt.eu-S2992737AbXDRPJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992737AbXDRPJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 11:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992735AbXDRPJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 11:09:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45571 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992734AbXDRPJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 11:09:04 -0400
Date: Wed, 18 Apr 2007 17:08:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Pfister <christophpfister@gmail.com>
Cc: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>,
       linux-kernel@vger.kernel.org, Michael Lothian <mike@fireburn.co.uk>,
       Christophe Thommeret <hftom@free.fr>, Jurgen Kofler <kaffeine@gmx.net>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: Kaffeine problem with CFS
Message-ID: <20070418150842.GA8546@elte.hu>
References: <19a3b7a80704180213i1ac84b2ch2b35220b62e3b67a@mail.gmail.com> <20070418091714.GA23446@elte.hu> <19a3b7a80704180225x3c8d6d60g366126862f05150@mail.gmail.com> <20070418092805.GA23125@elte.hu> <19a3b7a80704180252j72c955bcna5df5cb7057e6756@mail.gmail.com> <19a3b7a80704180304u72cc6612w2e6e0811226f1a52@mail.gmail.com> <20070418101041.GA30643@elte.hu> <19a3b7a80704180534w3688af87x78ee68cc1c330a5c@mail.gmail.com> <19a3b7a80704180555q4e0b26d5x54bbf34b4cd9d33e@mail.gmail.com> <19a3b7a80704180621m1b343b4eif02a7930a5edf2fc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19a3b7a80704180621m1b343b4eif02a7930a5edf2fc@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Pfister <christophpfister@gmail.com> wrote:

> Replacing the sched_yield in demux.c with an usleep(10) stopped those 
> seeking hangs here (at least I was able to pull the slider back and 
> forth during 2 mins without trouble compared to the few secs I need 
> earlier to get a hang).

great - thanks for figuring it out!

	Ingo
