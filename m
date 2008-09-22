Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbYIVSAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbYIVSAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYIVSAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:00:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35023 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881AbYIVSAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:00:03 -0400
Date: Mon, 22 Sep 2008 19:59:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, dzickus@redhat.com, prarit@redhat.com,
       vgoyal@redhat.com
Subject: Re: [PATCH] NMI watchdog: setup before enabling NMI watchdog
Message-ID: <20080922175953.GI10535@elte.hu>
References: <20080922171347.GI16840@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922171347.GI16840@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Aristeu Rozanski <aris@redhat.com> wrote:

> There's a small window when NMI watchdog is being set up that if any 
> NMIs are triggered, the NMI code will make make use of not initalized 
> wd_ops elements:

btw, this looks a bit large and not that easy to trigger, so i think 
it's v2.6.28 material - agreed?

	Ingo
