Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbYGZBx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbYGZBx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 21:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbYGZBxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 21:53:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44415 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752026AbYGZBxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 21:53:12 -0400
Date: Fri, 25 Jul 2008 18:52:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, alan@lxorguk.ukuu.org.uk,
       mingo@elte.hu, randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] hugetlb: fix CONFIG_SYSCTL=n build
Message-Id: <20080725185228.03afd676.akpm@linux-foundation.org>
In-Reply-To: <20080726012549.GA2019@us.ibm.com>
References: <20080721191519.GA15843@elte.hu>
	<20080721214258.787a67ca@lxorguk.ukuu.org.uk>
	<20080722072334.GA25241@elte.hu>
	<48865899.3030209@garzik.org>
	<20080723104520.GA20672@elte.hu>
	<20080724052603.GA8744@elte.hu>
	<20080725180935.5bd02bf5@lxorguk.ukuu.org.uk>
	<20080725203351.GA18407@us.ibm.com>
	<alpine.LFD.1.10.0807251732160.4188@nehalem.linux-foundation.org>
	<20080725174456.cb340675.akpm@linux-foundation.org>
	<20080726012549.GA2019@us.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2008 18:25:49 -0700 Nishanth Aravamudan <nacc@us.ibm.com> wrote:

> On 25.07.2008 [17:44:56 -0700], Andrew Morton wrote:
> > On Fri, 25 Jul 2008 17:32:38 -0700 (PDT)
> > Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > > 
> > > 
> > > On Fri, 25 Jul 2008, Nishanth Aravamudan wrote:
> > > >
> > > > [resending with Linus' address fixed]
> > > 
> > > Hmm, this doesn't apply for me any more. Can you check the current
> > > -git tree?
> > > 
> > 
> > Is OK, I have a fixed-up version here which I'm about to start testing.
> 
> Ah, I see that Linus had already picked up Ingo's fix
> (e44d1b2998d62a1f2f4d7eb17b56ba396535509f).

Yeah, that fixes the build but tosses out a storm of
unused-static-function warnings.

> While that does fix the
> build, it isn't really the right solution. I'm guessing Andrew's version
> will be a revert (either real or in patch-form) of that commit and an
> application of mine?

I'll fix it up.
