Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbYGZB0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbYGZB0O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 21:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbYGZBZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 21:25:59 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:46695 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbYGZBZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 21:25:58 -0400
Date: Fri, 25 Jul 2008 18:25:49 -0700
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, alan@lxorguk.ukuu.org.uk,
       mingo@elte.hu, randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] hugetlb: fix CONFIG_SYSCTL=n build
Message-ID: <20080726012549.GA2019@us.ibm.com>
References: <20080721191519.GA15843@elte.hu> <20080721214258.787a67ca@lxorguk.ukuu.org.uk> <20080722072334.GA25241@elte.hu> <48865899.3030209@garzik.org> <20080723104520.GA20672@elte.hu> <20080724052603.GA8744@elte.hu> <20080725180935.5bd02bf5@lxorguk.ukuu.org.uk> <20080725203351.GA18407@us.ibm.com> <alpine.LFD.1.10.0807251732160.4188@nehalem.linux-foundation.org> <20080725174456.cb340675.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080725174456.cb340675.akpm@linux-foundation.org>
X-Operating-System: Linux 2.6.26-rc9-00132-g9df2fe9 (x86_64)
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.07.2008 [17:44:56 -0700], Andrew Morton wrote:
> On Fri, 25 Jul 2008 17:32:38 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > 
> > 
> > On Fri, 25 Jul 2008, Nishanth Aravamudan wrote:
> > >
> > > [resending with Linus' address fixed]
> > 
> > Hmm, this doesn't apply for me any more. Can you check the current
> > -git tree?
> > 
> 
> Is OK, I have a fixed-up version here which I'm about to start testing.

Ah, I see that Linus had already picked up Ingo's fix
(e44d1b2998d62a1f2f4d7eb17b56ba396535509f). While that does fix the
build, it isn't really the right solution. I'm guessing Andrew's version
will be a revert (either real or in patch-form) of that commit and an
application of mine?

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center
