Return-Path: <linux-kernel-owner+w=401wt.eu-S1753647AbYEFVbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbYEFVbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 17:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933043AbYEFVVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 17:21:33 -0400
Received: from www.tglx.de ([62.245.132.106]:39147 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933416AbYEFVVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 17:21:32 -0400
Date: Tue, 6 May 2008 23:19:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Walker <dwalker@mvista.com>
cc: akpm@linux-foundation.org, johnstul@us.ibm.com, ralf@linux-mips.org,
       anemo@mba.ocn.ne.jp, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clocksource: shift helper
In-Reply-To: <1210107675.17132.181.camel@localhost.localdomain>
Message-ID: <alpine.LFD.1.10.0805062303060.3318@apollo.tec.linutronix.de>
References: <20080501173123.444094226@mvista.com>  <alpine.LFD.1.10.0805060250410.3318@apollo.tec.linutronix.de>  <1210091954.17132.142.camel@localhost.localdomain>  <alpine.LFD.1.10.0805061854310.3318@apollo.tec.linutronix.de>  <1210106014.17132.172.camel@localhost.localdomain>
  <alpine.LFD.1.10.0805062242020.3318@apollo.tec.linutronix.de> <1210107675.17132.181.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008, Daniel Walker wrote:
> On Tue, 2008-05-06 at 22:53 +0200, Thomas Gleixner wrote:
> > 
> > And your description led me to the assumption that the code was pulled
> > from the MIPS git tree and not from the MIPS architecture code in
> > mainline. Everyone else I talked to was having the same impression.
> > 
> > I was wrong, but can you understand that your sloppy wording "pulled
> > from the MIPS tree" along with the fact that you just copied code
> > instead of moving it into the generic space and cleanup the MIPS code
> > where it is duplicated from is causing such a misunderstanding ?
> 
> You could have asked me if it was mainline or not. I can see how words
> could be misunderstood .

You - the patch submitter - have to provide useful information to
those who review the patches and not the reviewers are supposed to
decode your sloppy commit log.

"... which I pulled from the MIPS tree"

Why should I assume that this is from mainline ?

> > I'm fine with the change itself, but it needs to move the code out of
> > MIPS in the first place and not just duplicating code for no good
> > reason.
> 
> I can work with Atsushi, but I still think the generic version should be
> merged. We at least would need it in order to modify the mips code.

You can think what you want, it's not the way it works.

You duplicate code, so the first thing to do is to replace the code
which you copied and make sure it is still fully functional. Then you
can add a second user to make the point that the generic code move is
actually useful. btw, pmtimer is the worst example for a good use case
as everything there is constant so we can do it at compile time.

Thanks,
	tglx

