Return-Path: <linux-kernel-owner+w=401wt.eu-S1759317AbZFZMXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317AbZFZMXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 08:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756451AbZFZMXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 08:23:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51027 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758044AbZFZMXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 08:23:07 -0400
Date: Fri, 26 Jun 2009 14:22:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 3/9] x86/moorestown: add moorestown platform flags
Message-ID: <20090626122254.GA9959@elte.hu>
References: <43F901BD926A4E43B106BF17856F07556412B7E2@orsmsx508.amr.corp.intel.com> <20090626071955.GG14078@elte.hu> <20090626101310.4110a290@lxorguk.ukuu.org.uk> <20090626093859.GA12571@elte.hu> <20090626111603.758ec7fb@lxorguk.ukuu.org.uk> <20090626110429.GB12446@elte.hu> <20090626125653.5e30bae4@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090626125653.5e30bae4@lxorguk.ukuu.org.uk>
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

> > > The flags are passed by the boot loader which is the one thing 
> > > that knows what the platform is only deeply embedded hardware. See 
> > > the ARM and PPC ports.
> > 
> > And? There's an obvious quality difference between various 
> > platform enumeration methods - and we strive for the highest 
> > quality methods.
> 
> Good the boot loader knows precisely what it is running on

That's a pretty bogus claim - on x86 a bootloader generally knows 
very little about 'what it is running on'. We do most of the 
enumeration in early platform code and retrieve information via 
standard BIOS interfaces.

> > Using boot flags is one of the lowest quality enumeration 
> > methods
> 
> It's probably the most reliable. If you don't believe so then 
> provide data to back your assertion

You are the one who is trying to do a change here really, so you 
should provide data to back your assertion that all existing x86 
enumeration methods are wrong and that modern x86 platforms from
now on should freely splinter into non-standard platforms along
boot flags.

The success of the PC platform was based on standardization and 
standard interfaces. Do you need data for that fact? ;-)

> > and the fact that there's precedence for it in other 
> > architectures is not a technical reason to make the same 
> > mistakes on x86 too.
> 
> How about "they tried other methods and they didn't work"

The thing is, you are trying to defend a v1 patch-set here that is 
really indefensible: it's ugly and deficient in numerous smaller and 
larger details. I outlined numerous deficiencies already - and i'll 
review v2 too to see what else is there to fix.

You outlined here various claims about how x86 should suddenly 
change into ARM or PPC to become 'successful' - but if this current 
patch-set is your attempt at that then it has failed spectacularly. 

Thanks,

	Ingo
