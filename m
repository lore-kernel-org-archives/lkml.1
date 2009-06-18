Return-Path: <linux-kernel-owner+w=401wt.eu-S1755227AbZFRA5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbZFRA5u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 20:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbZFRA5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 20:57:39 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35075 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbZFRA5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 20:57:38 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH for -mm] getrusage: fill ru_maxrss value
Cc: kosaki.motohiro@jp.fujitsu.com, Hugh Dickins <hugh@veritas.com>,
       jpirko@redhat.com, linux-kernel@vger.kernel.org, oleg@redhat.com,
       linux-mm@kvack.org, mingo@elte.hu
In-Reply-To: <20090617132118.ef839ad7.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0904060811300.22841@blonde.anvils> <20090617132118.ef839ad7.akpm@linux-foundation.org>
Message-Id: <20090618095705.99D2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 18 Jun 2009 09:57:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 6 Apr 2009 08:22:07 +0100 (BST)
> Hugh Dickins <hugh@veritas.com> wrote:
> 
> > On Mon, 6 Apr 2009, KOSAKI Motohiro wrote:
> > > 
> > > > I'm worrying particularly about the fork/exec issue you highlight.
> > > > You're exemplary in providing your test programs, but there's a big
> > > > omission: you don't mention that the first test, "./getrusage -lc",
> > > > gives a very different result on Linux than you say it does on BSD -
> > > > you say the BSD fork line is "fork: self 0 children 0", whereas
> > > > I find my Linux fork line is "fork: self 102636 children 0".
> > > 
> > > FreeBSD update rusage at tick updating point. (I think all bsd do that)
> > > Then, bsd displaing 0 is bsd's problem :)
> > 
> > Ah, thank you.
> > 
> > > 
> > > Do I must change test program?
> > 
> > Apparently somebody needs to, please; though it appears to be already
> > well supplied with usleep(1)s - maybe they needed to be usleep(2)s?
> > 
> > And then change results shown in the changelog, and check conclusions
> > drawn from them (if BSD is behaving as we do, it should still show
> > maxrss not inherited over fork, but less obviously - the number goes
> > down slightly, because the history is lost, but nowhere near to zero).
> > 
> 
> afaik none of this happened, so I have the patch on hold.

Grr, my fault.
I recognize it. sorry.





