Return-Path: <linux-kernel-owner+w=401wt.eu-S965256AbXG0X3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965256AbXG0X3d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 19:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756499AbXG0X3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 19:29:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49870 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760890AbXG0X3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 19:29:24 -0400
Date: Sat, 28 Jul 2007 01:29:19 +0200
From: Andi Kleen <andi@firstfloor.org>
To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       Rene Herman <rene.herman@gmail.com>,
       Daniel Hazelton <dhazelton@enter.net>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Frank Kingswood <frank@kingswood-consulting.co.uk>,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Ray Lee <ray-lk@madrabbit.org>, Jesper Juhl <jesper.juhl@gmail.com>,
       ck list <ck@vds.kolivas.org>, Paul Jackson <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: RFT: updatedb "morning after" problem [was: Re: -mm merge plans for 2.6.23]
Message-ID: <20070727232919.GA8960@one.firstfloor.org>
References: <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com> <20070727030040.0ea97ff7.akpm@linux-foundation.org> <1185531918.8799.17.camel@Homer.simpson.net> <200707271345.55187.dhazelton@enter.net> <46AA3680.4010508@gmail.com> <20070727231545.GA14457@atjola.homenet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070727231545.GA14457@atjola.homenet>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Any faults in that reasoning?

GNU sort uses a merge sort with temporary files on disk. Not sure
how much it keeps in memory during that, but it's probably less
than 150MB. At some point the dirty limit should kick in and write back the 
data of the temporary files; so it's not quite the same as anonymous memory. 
But it's not that different given.

It would be better to measure than to guess. At least Andrew's measurements
on 128MB actually didn't show updatedb being really that big a problem.

Perhaps some people have much more files or simply a less efficient
updatedb implementation?

I guess the people who complain here that loudly really need to supply
some real numbers. 

-Andi
