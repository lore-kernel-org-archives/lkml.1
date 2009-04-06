Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311AbZDFAV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbZDFAV4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 20:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbZDFAVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 20:21:45 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45633 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbZDFAVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 20:21:44 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH for -mm] getrusage: fill ru_maxrss value
Cc: kosaki.motohiro@jp.fujitsu.com, Jiri Pirko <jpirko@redhat.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       oleg@redhat.com, linux-mm@kvack.org, mingo@elte.hu
In-Reply-To: <Pine.LNX.4.64.0904051736210.23536@blonde.anvils>
References: <20090405084902.GA4411@psychotron.englab.brq.redhat.com> <Pine.LNX.4.64.0904051736210.23536@blonde.anvils>
Message-Id: <20090406091825.44F0.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Mon,  6 Apr 2009 09:21:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> I'm worrying particularly about the fork/exec issue you highlight.
> You're exemplary in providing your test programs, but there's a big
> omission: you don't mention that the first test, "./getrusage -lc",
> gives a very different result on Linux than you say it does on BSD -
> you say the BSD fork line is "fork: self 0 children 0", whereas
> I find my Linux fork line is "fork: self 102636 children 0".

FreeBSD update rusage at tick updating point. (I think all bsd do that)
Then, bsd displaing 0 is bsd's problem :)

Do I must change test program?

> So after that discrepancy, I can't tell what to expect.  Not that
> I can make any sense of BSD's "self 0" there - I don't know how
> you could present 0 there if this is related to hiwater_rss.
> 
> Now I'm seriously wondering if the ru_maxrss reported will generate
> more bugreports from people puzzled as to how it should behave,
> than help anyone in studying their process behaviour.
> 
> Sorry to be so negative after all this time: I genuinely hope others
> will spring up to defend your patch and illustrate my stupidity.





