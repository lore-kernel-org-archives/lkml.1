Return-Path: <linux-kernel-owner+w=401wt.eu-S1761351AbZFQUWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761351AbZFQUWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 16:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755768AbZFQUWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 16:22:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60819 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756024AbZFQUWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 16:22:08 -0400
Date: Wed, 17 Jun 2009 13:21:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: kosaki.motohiro@jp.fujitsu.com, jpirko@redhat.com,
       linux-kernel@vger.kernel.org, oleg@redhat.com, linux-mm@kvack.org,
       mingo@elte.hu
Subject: Re: [PATCH for -mm] getrusage: fill ru_maxrss value
Message-Id: <20090617132118.ef839ad7.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0904060811300.22841@blonde.anvils>
References: <20090405084902.GA4411@psychotron.englab.brq.redhat.com>
	<Pine.LNX.4.64.0904051736210.23536@blonde.anvils>
	<20090406091825.44F0.A69D9226@jp.fujitsu.com>
	<Pine.LNX.4.64.0904060811300.22841@blonde.anvils>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Apr 2009 08:22:07 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:

> On Mon, 6 Apr 2009, KOSAKI Motohiro wrote:
> > 
> > > I'm worrying particularly about the fork/exec issue you highlight.
> > > You're exemplary in providing your test programs, but there's a big
> > > omission: you don't mention that the first test, "./getrusage -lc",
> > > gives a very different result on Linux than you say it does on BSD -
> > > you say the BSD fork line is "fork: self 0 children 0", whereas
> > > I find my Linux fork line is "fork: self 102636 children 0".
> > 
> > FreeBSD update rusage at tick updating point. (I think all bsd do that)
> > Then, bsd displaing 0 is bsd's problem :)
> 
> Ah, thank you.
> 
> > 
> > Do I must change test program?
> 
> Apparently somebody needs to, please; though it appears to be already
> well supplied with usleep(1)s - maybe they needed to be usleep(2)s?
> 
> And then change results shown in the changelog, and check conclusions
> drawn from them (if BSD is behaving as we do, it should still show
> maxrss not inherited over fork, but less obviously - the number goes
> down slightly, because the history is lost, but nowhere near to zero).
> 

afaik none of this happened, so I have the patch on hold.
