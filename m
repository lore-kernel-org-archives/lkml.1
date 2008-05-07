Return-Path: <linux-kernel-owner+w=401wt.eu-S1763464AbYEGR0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763464AbYEGR0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 13:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755391AbYEGR0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 13:26:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59454 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754641AbYEGR0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 13:26:00 -0400
Date: Wed, 7 May 2008 19:25:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-ID: <20080507172542.GA13389@elte.hu>
References: <1210052904.3453.30.camel@ymzhang> <20080506114449.GC32591@elte.hu> <20080506120934.GH19219@parisc-linux.org> <20080506162332.GI19219@parisc-linux.org> <20080506102153.5484c6ac.akpm@linux-foundation.org> <20080507163811.GY19219@parisc-linux.org> <alpine.LFD.1.10.0805070948250.3024@woody.linux-foundation.org> <alpine.LFD.1.10.0805070956060.3024@woody.linux-foundation.org> <20080507172246.GA13262@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080507172246.GA13262@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> There's far more normal mutex fastpath use during an AIM7 run than any 
> BKL use. So if it's due to any direct fastpath overhead and the 
> resulting widening of the window for the real slowdown, we should see 
> a severe slowdown on AIM7 with CONFIG_MUTEX_DEBUG=y. Agreed?

my own guesstimate about AIM7 performance impact resulting out of 
CONFIG_MUTEX_DEBUG=y: performance overhead will not be measurable, or 
will at most be in the sub-1% range. But i've been badly wrong before :)

	Ingo
