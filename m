Return-Path: <linux-kernel-owner+w=401wt.eu-S1755474AbYEIIzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbYEIIzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 04:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbYEIIza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 04:55:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60195 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262AbYEIIz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 04:55:29 -0400
Date: Fri, 9 May 2008 10:55:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Takashi Iwai <tiwai@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>, Glauber Costa <gcosta@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Pete Clements <clem@clem.clem-digital.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       ALSA devel <alsa-devel@alsa-project.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.26-rc1 regression: ISA DMA broken (bisected)
Message-ID: <20080509085511.GE2592@elte.hu>
References: <4823AAF2.7070102@keyaccess.nl> <s5hzlr0105c.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hzlr0105c.wl%tiwai@suse.de>
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


* Takashi Iwai <tiwai@suse.de> wrote:

> Thanks for catching it.  Yeah, the patch looks buggy.  We had an 
> implicit assumption that dev = NULL for ISA devices that require 24bit 
> DMA.
> 
> How about the patch below?  It's against the latest Linus git tree.

good catch! Queued it up for testing. Jesse, do you concur?

	Ingo
