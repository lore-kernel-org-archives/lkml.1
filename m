Return-Path: <linux-kernel-owner+w=401wt.eu-S1756390AbZC1Xym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390AbZC1Xym (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 19:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbZC1Xyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 19:54:32 -0400
Received: from mail.lang.hm ([64.81.33.126]:37785 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbZC1Xyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 19:54:31 -0400
Date: Sat, 28 Mar 2009 16:52:14 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <alpine.LFD.2.00.0903262044050.3994@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0903281647150.22577@asgard.lang.hm>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <49C88C80.5010803@krogh.cc> <72dbd3150903241200v38720ca0x392c381f295bdea@mail.gmail.com>
 <20090325183011.GN32307@mit.edu> <alpine.LFD.2.00.0903251139260.3032@localhost.localdomain> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org>
 <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <alpine.LFD.2.00.0903262035270.3994@localhost.localdomain>
 <alpine.LFD.2.00.0903262044050.3994@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Mar 2009, Linus Torvalds wrote:

> On Thu, 26 Mar 2009, Linus Torvalds wrote:
>>
>
> The only excuse _ever_ for user-land tweaking is if you do something
> really odd. Say that you want to get the absolutely best OLTP numbers you
> can possibly get - with no regards for _any_ other workload. In that case,
> you want to tweak the numbers for that exact load, and the exact machine
> that runs it - and the result is going to be a totally worthless number
> (since it's just benchmarketing and doesn't actually reflect any real
> world scenario), but hey, that's what benchmarketing is all about.
>
> Or say that you really are a very embedded environment, with a very
> specific load. A router, a cellphone, a base station, whatever - you do
> one thing, and you're not trying to be a general purpose machine. Then you
> can tweak for that load. But not otherwise.
>
> If you don't have any magical odd special workloads, you shouldn't need to
> tweak a single kernel knob. Because if you need to, then the kernel is
> doing something wrong to begin with.

while I agree with most of what you say, I'll point out that many 
enterprise servers really do care about one particular workload to the 
exclusion of everything else. if you can get another 10% performance by 
tuning your box for an OLTP workload and make your cluster 9 boxes instead 
of 10 it's well worth it (it ends up being better response time for users, 
less hardware, and avoiding software license costs most of the time"

this is somewhere between benchmarking and embedded, but it is a valid 
case.

most users (even most database users) don't need to go after that last 
little bit of performance, the defalts should be good enough for most 
users, no matter what workload they are running.

David Lang
