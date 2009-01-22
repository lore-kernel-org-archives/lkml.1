Return-Path: <linux-kernel-owner+w=401wt.eu-S1759966AbZAVXmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759966AbZAVXmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 18:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbZAVXml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 18:42:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46367 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbZAVXmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 18:42:40 -0500
Date: Fri, 23 Jan 2009 00:41:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: kyle@infradead.org
Cc: Greg KH <gregkh@suse.de>, Dave Jones <davej@redhat.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>, J?rn Engel <joern@logfs.org>,
       David Brown <lkml@davidb.org>, Phil Oester <kernel@linuxace.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       Christoph Hellwig <hch@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
Message-ID: <20090122234145.GA469@elte.hu>
References: <20090110101235.7ca24c44.akpm@linux-foundation.org> <20090110221528.GA31774@elte.hu> <Pine.LNX.4.64.0901111022590.30201@anakin> <20090111153920.GC7401@elte.hu> <20090111163018.GA9300@suse.de> <20090122215041.GA29369@redhat.com> <20090122215817.GA27609@suse.de> <20090122225025.GA21879@bombadil.infradead.org> <20090122230457.GA24745@suse.de> <20090122233439.GB21879@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090122233439.GB21879@bombadil.infradead.org>
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


* Kyle McMartin <kyle@redhat.com> wrote:

> On Thu, Jan 22, 2009 at 03:04:57PM -0800, Greg KH wrote:
> > > Why does it need to be upstream for someone to cut their teeth helping
> > > out?
> > Because people don't know where to look if it is out-of-the tree.
> > Seriously, if it can't be easily found, it's not fixed up.  Proof of
> > that is the hundreds of out-of-tree drivers that I have found over the
> > past months.
> 
> What about the hundreds of utterly crap drivers we have *right now* in 
> the kernel? Just because something is distributed with the kernel does 
> *not* mean it will get cleaned up. There's hundreds of counterexamples 
> to that. If you think moving some of them to drivers/staging to increase 
> the "visibility" to people looking for low hanging fruit, I can generate 
> a list...

that is true and it does not contradict the purpose and intention of 
drivers/staging/ though - it extends it.

We could create drivers/staging/in/ and drivers/staging/out/.

So instead of marking drivers CONFIG_BROKEN we could move them to 
drivers/staging/out/ - and if they dont get 'saved' within a kernel 
release they will be zapped for good. That is more gradual than a sudden 
'remove a driver completely' action.

	Ingo
