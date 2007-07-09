Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbXGIKfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbXGIKfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 06:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbXGIKfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 06:35:31 -0400
Received: from ns2.suse.de ([195.135.220.15]:42383 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbXGIKfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 06:35:31 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Please revert 21564fd2a3deb48200b595332f9ed4c9f311f2a7
Date: Mon, 9 Jul 2007 12:35:09 +0200
User-Agent: KMail/1.9.6
Cc: Adrian Bunk <bunk@stusta.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <20070617214231.GA3588@stusta.de> <200707091139.25240.ak@suse.de> <20070709110605.4efaea8b@the-village.bc.nu>
In-Reply-To: <20070709110605.4efaea8b@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707091235.09772.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 July 2007 12:06:05 Alan Cox wrote:
> On Mon, 9 Jul 2007 11:39:25 +0200
> Andi Kleen <ak@suse.de> wrote:
> 
> > 
> > > > It will be solved differently longer term, but short term the fix
> > > > was still needed. There are limits on what can be done late 
> > > > in the release cycle so simple patches win.
> > > 
> > > Your patch got into Linus' tree in the middle of the merge window...
> > 
> > Even in the middle of the merge window it might be too late
> > to do some large scale restructuring (as would have been needed
> > for this particular issue) 
> 
> You should have reverted the change and held it over for 2.6.23-rc1 then
> as other developers do with problem code.

Didn't seem justified. 

If someone really wanted to do evil binary only virtualization there
are lots of other ways to do this anyways (e.g. just patching the code
or looking for the paravirt_ops struct signature in memory) 

-Andi
