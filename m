Return-Path: <linux-kernel-owner+w=401wt.eu-S1752326AbZCNAOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbZCNAOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbZCNAOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:14:00 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:38871 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbZCNAN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:13:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oUQbehZm10Y+LnkHGiEbhUujrfLLUXjalJTHS54gq+TNGh8Vr9CMFVsnn+q47XMUAg
         /uhOKxwnEUDoQUil/kmvWqVT7dLByudoaSOLtxVMyL7kPGkHPbw7nMjoz8DlaFQr6O8o
         o93tOKFqZYdRXMmPAa5RAV5VlWI/KoiIqHwX8=
Date: Sat, 14 Mar 2009 03:20:59 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Ying Han <yinghan@google.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       linux-api@vger.kernel.org, containers@lists.linux-foundation.org,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
       viro@zeniv.linux.org.uk, mingo@elte.hu, mpm@selenic.com,
       Andrew Morton <akpm@linux-foundation.org>, xemul@openvz.org,
       tglx@linutronix.de
Subject: Re: How much of a mess does OpenVZ make? ;) Was: What can OpenVZ
	do?
Message-ID: <20090314002059.GA4167@x200.localdomain>
References: <20090310215305.GA2078@x200.localdomain> <49B775B4.1040800@free.fr> <20090312145311.GC12390@us.ibm.com> <1236891719.32630.14.camel@bahia> <20090312212124.GA25019@us.ibm.com> <604427e00903122129y37ad791aq5fe7ef2552415da9@mail.gmail.com> <20090313053458.GA28833@us.ibm.com> <alpine.LFD.2.00.0903131018390.3940@localhost.localdomain> <20090313193500.GA2285@x200.localdomain> <alpine.LFD.2.00.0903131401070.3940@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903131401070.3940@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 02:01:50PM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 13 Mar 2009, Alexey Dobriyan wrote:
> > > 
> > > Let's face it, we're not going to _ever_ checkpoint any kind of general 
> > > case process. Just TCP makes that fundamentally impossible in the general 
> > > case, and there are lots and lots of other cases too (just something as 
> > > totally _trivial_ as all the files in the filesystem that don't get rolled 
> > > back).
> > 
> > What do you mean here? Unlinked files?
> 
> Or modified files, or anything else. "External state" is a pretty damn 
> wide net. It's not just TCP sequence numbers and another machine.

I think (I think) you're seriously underestimating what's doable with
kernel C/R and what's already done.

I was told (haven't seen it myself) that Oracle installations and
Counter Strike servers were moved between boxes just fine.

They were run in specially prepared environment of course, but still.
