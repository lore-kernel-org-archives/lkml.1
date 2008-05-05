Return-Path: <linux-kernel-owner+w=401wt.eu-S1759291AbYEETFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291AbYEETFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765957AbYEETEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:04:51 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:41071 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763820AbYEETEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:04:50 -0400
Date: Mon, 5 May 2008 21:05:24 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Sergio Luis <sergio@uece.br>
Cc: Ingo Molnar <mingo@elte.hu>, Parag Warudkar <parag.warudkar@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "akpm@osdl.org" <akpm@osdl.org>, Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] default to n for GROUP_SCHED and FAIR_GROUP_SCHED
Message-ID: <20080505190524.GB4498@uranus.ravnborg.org>
References: <82e4877d0805031742o464dd581wd93173d79705ce0d@mail.gmail.com> <20080504092417.GA3425@elte.hu> <82e4877d0805050814j721ae522k84384df48c9f4336@mail.gmail.com> <20080505171501.GA22332@elte.hu> <20080505182427.GA2025@uranus.ravnborg.org> <ce0170d90805051136w2f016c15p575623d33c220ddf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce0170d90805051136w2f016c15p575623d33c220ddf@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Can I specify /proc/config.gz (gzipped) in the K parameter?

No. And I have more or less dropped my plans to support it.
I will instead try to find a way to read from stdin so you can
just cat or zcat any config.

So somthing along the lines of:

zcat /proc/config.gz | make K=- alldefconfig

	Sam
