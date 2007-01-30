Return-Path: <linux-kernel-owner+w=401wt.eu-S965431AbXA3IYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965431AbXA3IYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 03:24:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965447AbXA3IYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 03:24:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58067 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965431AbXA3IYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 03:24:30 -0500
Date: Tue, 30 Jan 2007 09:22:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@osdl.org>
Cc: Tomasz Kvarsin <kvarsin@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.20-rc3-mm1: can not mount root
Message-ID: <20070130082244.GA5942@elte.hu>
References: <5157576d0701050620l14fd0a6emdf5793c5214931a8@mail.gmail.com> <20070130001209.b716c14a.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070130001209.b716c14a.akpm@osdl.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -3.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-3.3 required=5.9 tests=ALL_TRUSTED autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@osdl.org> wrote:

> Tomasz, is this still happening in 2.6.20-rc6-mm3?
> 
> err.  We merged that patch.  So perhaps 2.6.20-rc6 now crashes in the 
> same manner?

no, we havent merged that patch yet, but it's:

  x86_64-mm-improve-sched_clock-on-i686.patch

I bet this is due to Qemu simulating a CPU that does not truly exist. 
I'll try to reproduce this.

	Ingo
