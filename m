Return-Path: <linux-kernel-owner+w=401wt.eu-S1754261AbZCNINo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbZCNINo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 04:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbZCNINZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 04:13:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45503 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbZCNINV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 04:13:21 -0400
Date: Sat, 14 Mar 2009 09:12:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>, Dave Hansen <dave@linux.vnet.ibm.com>,
       linux-api@vger.kernel.org, containers@lists.linux-foundation.org,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-mm@kvack.org,
       viro@zeniv.linux.org.uk, mpm@selenic.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, tglx@linutronix.de,
       xemul@openvz.org
Subject: Re: How much of a mess does OpenVZ make? ;) Was: What can OpenVZ
	do?
Message-ID: <20090314081207.GA16436@elte.hu>
References: <1236891719.32630.14.camel@bahia> <20090312212124.GA25019@us.ibm.com> <604427e00903122129y37ad791aq5fe7ef2552415da9@mail.gmail.com> <20090313053458.GA28833@us.ibm.com> <alpine.LFD.2.00.0903131018390.3940@localhost.localdomain> <20090313193500.GA2285@x200.localdomain> <alpine.LFD.2.00.0903131401070.3940@localhost.localdomain> <1236981097.30142.251.camel@nimitz> <49BADAE5.8070900@cs.columbia.edu> <m1hc1xrlt5.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1hc1xrlt5.fsf@fess.ebiederm.org>
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


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> >> In the OpenVZ case, they've at least demonstrated that the 
> >> filesystem can be moved largely with rsync.  Unlinked files 
> >> need some in-kernel TLC (or /proc mangling) but it isn't 
> >> *that* bad.
> >
> > And in the Zap we have successfully used a log-based 
> > filesystem (specifically NILFS) to continuously snapshot the 
> > file-system atomically with taking a checkpoint, so it can 
> > easily branch off past checkpoints, including the file 
> > system.
> >
> > And unlinked files can be (inefficiently) handled by saving 
> > their full contents with the checkpoint image - it's not a 
> > big toll on many apps (if you exclude Wine and UML...). At 
> > least that's a start.
> 
> Oren we might want to do a proof of concept implementation 
> like I did with network namespaces.  That is done in the 
> community and goes far enough to show we don't have horribly 
> nasty code.  The patches and individual changes don't need to 
> be quite perfect but close enough that they can be considered 
> for merging.
> 
> For the network namespace that seems to have made a big 
> difference.
> 
> I'm afraid in our clean start we may have focused a little too 
> much on merging something simple and not gone far enough on 
> showing that things will work.
> 
> After I had that in the network namespace and we had a clear 
> vision of the direction.  We started merging the individual 
> patches and things went well.

I'm curious: what is the actual end result other than good 
looking code? In terms of tangible benefits to the everyday 
Linux distro user. [This is not meant to be sarcastic, i'm
truly curious.]

	Ingo
