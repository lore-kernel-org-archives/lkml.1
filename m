Return-Path: <linux-kernel-owner+w=401wt.eu-S1759610AbZCMVLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759610AbZCMVLq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 17:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756662AbZCMVLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 17:11:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755463AbZCMVLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 17:11:37 -0400
Date: Fri, 13 Mar 2009 14:01:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Ying Han <yinghan@google.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       linux-api@vger.kernel.org, containers@lists.linux-foundation.org,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
       viro@zeniv.linux.org.uk, mingo@elte.hu, mpm@selenic.com,
       Andrew Morton <akpm@linux-foundation.org>, xemul@openvz.org,
       tglx@linutronix.de
Subject: Re: How much of a mess does OpenVZ make? ;) Was: What can OpenVZ
 do?
In-Reply-To: <20090313193500.GA2285@x200.localdomain>
Message-ID: <alpine.LFD.2.00.0903131401070.3940@localhost.localdomain>
References: <1234479845.30155.220.camel@nimitz> <20090226155755.GA1456@x200.localdomain> <20090310215305.GA2078@x200.localdomain> <49B775B4.1040800@free.fr> <20090312145311.GC12390@us.ibm.com> <1236891719.32630.14.camel@bahia> <20090312212124.GA25019@us.ibm.com>
 <604427e00903122129y37ad791aq5fe7ef2552415da9@mail.gmail.com> <20090313053458.GA28833@us.ibm.com> <alpine.LFD.2.00.0903131018390.3940@localhost.localdomain> <20090313193500.GA2285@x200.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 13 Mar 2009, Alexey Dobriyan wrote:
> > 
> > Let's face it, we're not going to _ever_ checkpoint any kind of general 
> > case process. Just TCP makes that fundamentally impossible in the general 
> > case, and there are lots and lots of other cases too (just something as 
> > totally _trivial_ as all the files in the filesystem that don't get rolled 
> > back).
> 
> What do you mean here? Unlinked files?

Or modified files, or anything else. "External state" is a pretty damn 
wide net. It's not just TCP sequence numbers and another machine.

		Linus
