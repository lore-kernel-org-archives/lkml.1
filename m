Return-Path: <linux-kernel-owner+w=401wt.eu-S1758202AbZEEBOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202AbZEEBOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 21:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbZEEBOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 21:14:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753644AbZEEBOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 21:14:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: oleg@redhat.com, jdike@addtoit.com, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 0/2] utrace/ptrace: simplify/cleanup ptrace attach
In-Reply-To: Andrew Morton's message of  Monday, 4 May 2009 16:31:54 -0700 <20090504163154.f3672a83.akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <20090503185537.GA17071@redhat.com>
	<20090504184951.623CEFC32F@magilla.sf.frob.com>
	<20090504193016.GA17076@redhat.com>
	<20090504194348.BC0EBFC32F@magilla.sf.frob.com>
	<20090504163154.f3672a83.akpm@linux-foundation.org>
X-Zippy-Says: Is the EIGHTIES when they had ART DECO and GERALD McBOING-BOING
    lunch boxes??
Message-Id: <20090505011244.2BAE1FC2BD@magilla.sf.frob.com>
Date: Mon,  4 May 2009 18:12:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Staging the utrace patch at end-of-series would make sense if utrace is
> not on track for a 2.6.31 merge.
> 
> And afaict, this is indeed the case - things seem to have gone a bit
> quiet on the utrace front lately.

I don't think that is really accurate.  There has been a lack of any
reviewer comments on the actual content of the utrace patch (aside from
Oleg's own), which is indeed quieter on that front than I had expected.

The comments we did get, e.g. from hch, were that a compelling user of the
API should go in, such as converting ptrace.  Oleg's current ptrace revamp
work will culminate in replacing its innards with utrace calls.  It's my
hope that all this work will be ready in time for 2.6.31.

The reason the utrace patch should appear later in the series is that the
bulk of the ptrace cleanup series (including all patches done so far) will
not depend on utrace at all and will be mergeable independent of the fate
of utrace or that of any later utrace-dependent ptrace patches.  We expect
the utrace patch will get more updates that we hash out in the course of
the ptrace work.  That being so, it makes more sense (to me) to plan to
replace it later before merge time rather than include the old patch
earlier in the series and have other patches (including ones unrelated to
it) need to do incremental updates relative to it.


Thanks,
Roland
