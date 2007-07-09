Return-Path: <linux-kernel-owner+w=401wt.eu-S1756348AbXGIJks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbXGIJks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 05:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbXGIJk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 05:40:27 -0400
Received: from ns2.suse.de ([195.135.220.15]:39548 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbXGIJkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 05:40:25 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Please revert 21564fd2a3deb48200b595332f9ed4c9f311f2a7
Date: Mon, 9 Jul 2007 11:39:53 +0200
User-Agent: KMail/1.9.6
Cc: Adrian Bunk <bunk@stusta.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <20070617214231.GA3588@stusta.de> <200707090102.21784.ak@suse.de> <20070709103223.5bfe24d4@the-village.bc.nu>
In-Reply-To: <20070709103223.5bfe24d4@the-village.bc.nu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707091139.53952.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 July 2007 11:32:23 Alan Cox wrote:
> > It will be solved differently longer term, but short term the fix
> > was still needed. There are limits on what can be done late 
> > in the release cycle so simple patches win.
> > 
> > Besides none of the "NAK"s were particularly inspired in my opinion;
> > there were no clear technical objections brought forward.
> 
> 
> There were a considerable number of sensible logical objections. You just
> didn't agree with them.

Well they didn't offer a workable alternative (that's my definition for "not 
particularly inspired")

> You've now effectively made .22 unsupportable 
> since we don't know if someone has binary virtualiser crap loaded.

What binary virtualiser crap? 

The most common external patchers are probably root kits and those
don't really care about GPL or non GPL exports.

-Andi
