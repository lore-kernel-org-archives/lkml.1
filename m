Return-Path: <linux-kernel-owner+w=401wt.eu-S1755188AbYDIOvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbYDIOvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 10:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbYDIOvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 10:51:45 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:4702 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbYDIOvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 10:51:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=wP5ajLxQRFTFB5JnlYqHwmh2Pm8h2CsBAe3zFsvBaNt0AyoDfcG81YjZzNcQ6svD0pttmnkxXWZQuk8gKdoSi0CrRh2nxfIWOGo79T5kPKd4De3CrobdXtHNnXiE8fSqV2iY/6ds7g4vpehvh9Ryw9FIbnnjrjMZKm1m5xa9jXk=
Date: Wed, 9 Apr 2008 18:50:58 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Jacek Luczak <difrost.kernel@gmail.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 9
Message-ID: <20080409145058.GA7648@cvg>
References: <20080409185309.b94c9d15.sfr@canb.auug.org.au> <d711229d0804090400p1c92a158j381b86e207a6f38a@mail.gmail.com> <20080409210936.ec8ea986.sfr@canb.auug.org.au> <20080409212719.7d834c13.sfr@canb.auug.org.au> <20080409113109.GA25186@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080409113109.GA25186@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Wed, Apr 09, 2008 at 01:31:09PM +0200]
| 
| * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
| 
| > Hi Jacek,
| > 
| > On Wed, 9 Apr 2008 21:09:36 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
| > >
| > > Thanks for the report, can you please send us your .config, please?
| > 
| > Don't worry about it, I found the problem.
| > 
| > It seems that commit 883a9fc4e5d9b0701f15d4e5a23608f942104721 ("x86: 
| > cleanup - rename VM_MASK to X86_VM_MASK") from the x86 tree seems to 
| > have missed some places.
| 
| i think what happened is that some changes came in from other trees that 
| reintroduced the old symbols?

actually, that is the only explanation I could find. The last time I sent
you patches to fixup *all* VM_MASK (wich were grep'ed on *latest branch over
*all* sources inside x86). So this all were settled down by a few of my
patches and /for shame on me/ yours fixups. So these fixups were missed
on merging.

| 
| if that's the case i'll add back the old symbol names to make the 
| transition and integration easier.
| 
| 	Ingo
| 
		- Cyrill -
