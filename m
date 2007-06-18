Return-Path: <linux-kernel-owner+w=401wt.eu-S1760543AbXFRJog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760543AbXFRJog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 05:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757779AbXFRJo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 05:44:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53159 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbXFRJo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 05:44:28 -0400
Date: Mon, 18 Jun 2007 11:44:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: cebbert@redhat.com, chris@atlee.ca, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, kiran@scalex86.org
Subject: Re: [BUG] long freezes on thinkpad t60
Message-ID: <20070618094414.GA8261@elte.hu>
References: <20070616103707.GA28096@elte.hu> <E1I02Zx-0005qu-00@dorka.pomaz.szeredi.hu> <20070618064343.GA31113@elte.hu> <E1I0Baz-0006cP-00@dorka.pomaz.szeredi.hu> <20070618081204.GA11153@elte.hu> <E1I0CY4-0006lF-00@dorka.pomaz.szeredi.hu> <20070618083109.GA23572@elte.hu> <E1I0ChN-0006nd-00@dorka.pomaz.szeredi.hu> <20070618091832.GA1860@elte.hu> <20070618093848.GA6880@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618093848.GA6880@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> how about the patch below? Boot-tested on 32-bit. As a side-effect 
> this change also removes the 255 CPUs limit from the 32-bit kernel.

boot-tested on 64-bit too now.

	Ingo
