Return-Path: <linux-kernel-owner+w=401wt.eu-S1760224AbZFZPBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224AbZFZPBG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 11:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbZFZPA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 11:00:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39560 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081AbZFZPA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 11:00:58 -0400
Date: Fri, 26 Jun 2009 17:00:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/9] x86/moorestown: add moorestown platform flags
Message-ID: <20090626150051.GA22223@elte.hu>
References: <43F901BD926A4E43B106BF17856F07556412B7E2@orsmsx508.amr.corp.intel.com> <20090626071955.GG14078@elte.hu> <20090626101310.4110a290@lxorguk.ukuu.org.uk> <20090626093859.GA12571@elte.hu> <20090626111603.758ec7fb@lxorguk.ukuu.org.uk> <20090626110429.GB12446@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090626110429.GB12446@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> And? There's an obvious quality difference between various 
> platform enumeration methods - and we strive for the highest 
> quality methods.
> 
> Using boot flags is one of the lowest quality enumeration methods 
> and the fact that there's precedence for it in other architectures 
> is not a technical reason to make the same mistakes on x86 too.
> 
> Especially here where there's two other enumeration methods easily 
> available: SFI and PCI. Any of those suffices.

btw., the "I am MRST" bootstrap info is certainly doable via a 
bootloader flag as well, if this platform is _so_ deprived of basic 
PC features that it has no other channel of information. Especially 
if it has no BIOS and if the bootloader provides the memory map as 
well - which seems to be the case here.

I can understand the PCI ID space being potentially awkward (if many 
models with mismatching PCI IDs are planned) - so it's certainly 
possible that the only thing that remains in the end is the 
bootloader provided flag - no matter how sucky that may be.

So i am not trying to make a bigger deal out of this than it really 
deserves and this is not a showstopper in my eyes - but this is 
really an exceptional case and shouldnt be the glory model for how 
ultra embedded should be done on x86 ...

	Ingo
