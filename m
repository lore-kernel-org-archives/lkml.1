Return-Path: <linux-kernel-owner+w=401wt.eu-S1760272AbZFZMva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760272AbZFZMva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 08:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759525AbZFZMvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 08:51:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48266 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760055AbZFZMvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 08:51:21 -0400
Date: Fri, 26 Jun 2009 14:51:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/9] x86/moorestown: add moorestown platform flags
Message-ID: <20090626125111.GA11575@elte.hu>
References: <43F901BD926A4E43B106BF17856F07556412B7E2@orsmsx508.amr.corp.intel.com> <20090626071955.GG14078@elte.hu> <20090626101310.4110a290@lxorguk.ukuu.org.uk> <20090626093859.GA12571@elte.hu> <20090626111603.758ec7fb@lxorguk.ukuu.org.uk> <20090626110429.GB12446@elte.hu> <20090626125653.5e30bae4@lxorguk.ukuu.org.uk> <20090626122254.GA9959@elte.hu> <20090626133318.5b8de81b@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090626133318.5b8de81b@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > That's a pretty bogus claim - on x86 a bootloader generally 
> > knows very little about 'what it is running on'. We do most of 
> > the enumeration in early platform code and retrieve information 
> > via standard BIOS interfaces.
> 
> Stop thinking about existing x86 PC systems running grub for a 
> bit. [...]

You are talking to the wrong person then i guess, i'm not going to 
ignore 95% of our installed base. ;-)

We will gladly take clean x86 patches that abstract away lowlevel 
details of x86 platforms, and have been taking them and have been 
writing them for a long time. If this patch-set can shape itself in 
such a way (as i requested), without hindering the common case, it 
is certainly welcome.

Generally, if you try to deviate from de facto standards then you 
better show a very good reason and much cleaner code than this 
deficient v1 patch-set.

Yes, platform abstraction is good if it's necessary and if it's done 
cleanly, and x86 certainly has a few things to learn in that area 
(it still has way too much platform spaghetti), but i'm not 
convinced here at all that it's necessary, and it's certainly not 
cleanly done at all. As i pointed it out in my review in detail, 
it's full of 'if (feature)' crap invading core platform code for 
example.

There's good examples as well, from the same quarters of Intel: for 
example i reviewed and commented on the related SFI patches a few 
days ago, and they looked distinctly clean and desirable.

Thanks,

	Ingo
