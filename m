Return-Path: <linux-kernel-owner+w=401wt.eu-S933157AbYEFU5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933157AbYEFU5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 16:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762284AbYEFU5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 16:57:04 -0400
Received: from www.tglx.de ([62.245.132.106]:44605 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760960AbYEFU5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 16:57:01 -0400
Date: Tue, 6 May 2008 22:53:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Walker <dwalker@mvista.com>
cc: akpm@linux-foundation.org, johnstul@us.ibm.com, ralf@linux-mips.org,
       anemo@mba.ocn.ne.jp, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clocksource: shift helper
In-Reply-To: <1210106014.17132.172.camel@localhost.localdomain>
Message-ID: <alpine.LFD.1.10.0805062242020.3318@apollo.tec.linutronix.de>
References: <20080501173123.444094226@mvista.com>  <alpine.LFD.1.10.0805060250410.3318@apollo.tec.linutronix.de>  <1210091954.17132.142.camel@localhost.localdomain>  <alpine.LFD.1.10.0805061854310.3318@apollo.tec.linutronix.de>
 <1210106014.17132.172.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008, Daniel Walker wrote:
> On Tue, 2008-05-06 at 22:25 +0200, Thomas Gleixner wrote:
> > On Tue, 6 May 2008, Daniel Walker wrote:
> > > On Tue, 2008-05-06 at 02:52 +0200, Thomas Gleixner wrote:
> > > > On Thu, 1 May 2008, Daniel Walker wrote:
> > > > 
> > > > > This is a little helper I pulled from the mips tree.
> > > > ... 
> > > > > Signed-off-by: Daniel Walker <dwalker@mvista.com>
> > > > 
> > > > And who is the original author of this little helper in the MIPS tree?
> > > 
> > > commit 16b7b2ac0148e839da86af8747b6fa4aad43a9b7
> > > Author: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> > 
> > Wouldn't it be appropriate to assign the authorship in the usual form
> > i.e.:
> > 
> > From: Atsushi Nemoto <anemo@mba.ocn.ne.jp> 
> > 
> > on top of the patch and keep the original changelog message intact
> > including the Signed-off-by of the author and Ralf ?
> > 
> > Aside of the broken S-O-B chain this is a blatant usurpation of
> > somebody else's work.
> > 
> 
> I took a function and modified it for my usage, which happens all the
> time.

And your description led me to the assumption that the code was pulled
from the MIPS git tree and not from the MIPS architecture code in
mainline. Everyone else I talked to was having the same impression.

I was wrong, but can you understand that your sloppy wording "pulled
from the MIPS tree" along with the fact that you just copied code
instead of moving it into the generic space and cleanup the MIPS code
where it is duplicated from is causing such a misunderstanding ?

I'm fine with the change itself, but it needs to move the code out of
MIPS in the first place and not just duplicating code for no good
reason.

Thanks,
	tglx
