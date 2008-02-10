Return-Path: <linux-kernel-owner+w=401wt.eu-S1751983AbYBJQAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbYBJQAH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 11:00:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbYBJP74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 10:59:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40033 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbYBJP7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 10:59:55 -0500
Date: Sun, 10 Feb 2008 16:59:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [4/6] consoles: polling support, kgdboc
Message-ID: <20080210155934.GB609@elte.hu>
References: <20080210071339.GD3851@elte.hu> <47AF011D.5050301@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AF011D.5050301@web.de>
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


* Jan Kiszka <jan.kiszka@web.de> wrote:

> Ingo Molnar wrote:
> > From: Jan Kiszka <jan.kiszka@siemens.com>
> > 
> 
> Well, actually not from me but from Jason. I think I just touched it 
> last for the configuration cleanups.

i restructured it in some major ways but wanted to keep the original 
author - thanks for pointing out that it was Jason not you - i've fixed 
that.

> However, this fragment is additionally required to avoid crashes when 
> doing runtime reconfigurations. To avoid the ifdef'ery of the original 
> version, I just killed the __init - tiny-linux people may cry now...

i wondered about that - indeed - applied.

	Ingo
