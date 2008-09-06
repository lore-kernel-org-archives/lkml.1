Return-Path: <linux-kernel-owner+w=401wt.eu-S1754275AbYIFSKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbYIFSKg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 14:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbYIFSK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 14:10:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43192 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393AbYIFSK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 14:10:26 -0400
Date: Sat, 6 Sep 2008 20:09:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Hugh Dickins <hugh@veritas.com>,
       =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: [PATCH RFC] x86: check for and defend against BIOS memory
	corruption
Message-ID: <20080906180950.GA18649@elte.hu>
References: <20080829102547.655440bf@lxorguk.ukuu.org.uk> <b170af450808290313x574b4561i3048ffca3e4da197@mail.gmail.com> <Pine.LNX.4.64.0808291120540.8561@blonde.site> <b170af450808290454m2f349ce3w4f400b0df0e105a2@mail.gmail.com> <48B7E6EE.9090901@tuffmail.co.uk> <Pine.LNX.4.64.0808291413260.12571@blonde.site> <b170af450808291039u7d036313x49acdaec079e6213@mail.gmail.com> <b170af450809041242n43a6ef70s47a2e3e068619af0@mail.gmail.com> <Pine.LNX.4.64.0809042056270.3012@blonde.site> <48C06989.6080307@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C06989.6080307@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> > I would prefer you both to use the minimal memmap= solutions for 
> > now; but others may disagree.
> 
> The fact that we're seeing this problem in two completely different 
> systems with different BIOSes and everything else makes me worried 
> that this is quite widespread.  It's only the persistence and 
> diligence of our bug reporters that we managed to work out that 
> they're the same problem.  How many other people are getting strange 
> crashes and haven't managed to correlate it any particular BIOS 
> interaction?  Or just happen to be corrupting memory we don't care 
> about right now, but is only a small code change or link order change 
> away from disaster?

please put this all behind a .config debug option that distros can turn 
on/off. Also, when it's enabled in the .config, there should be another 
.config option that marks it disabled by default but it can be enabled 
via a boot parameter.

Distro debug kernels will most likely enable the .config - even release 
kernels might enable it it, with default off - users can enable the boot 
switch if they suspect something, without having to build a new kernel.

	Ingo
