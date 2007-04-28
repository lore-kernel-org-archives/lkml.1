Return-Path: <linux-kernel-owner+w=401wt.eu-S965865AbXD1Q1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965865AbXD1Q1N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 12:27:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965880AbXD1Q1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 12:27:13 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56889 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965865AbXD1Q1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 12:27:10 -0400
Date: Sat, 28 Apr 2007 09:24:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bryan WU <bryan.wu@analog.com>
cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/33] 2.6.20-stable review
In-Reply-To: <1177742776.9029.17.camel@roc-desktop>
Message-ID: <alpine.LFD.0.98.0704280908230.9964@woody.linux-foundation.org>
References: <20070426165445.GA1898@kroah.com>  <1177668954.5969.18.camel@roc-desktop>
 <20070427151314.GA10281@suse.de>  <1177734084.9029.10.camel@roc-desktop> 
 <20070428054800.GA6267@suse.de> <1177742776.9029.17.camel@roc-desktop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Apr 2007, Bryan WU wrote:
> 
> You know, because the kernel development is so active and so many stable
> versions release, it is very hard to decide use which version for mass
> production, especially some embedded systems which does not often
> upgrade. 

I actually think that one of the advantages (at least that was the _plan_) 
of having kernel releases every two-to-three months is that for vendors 
who don't upgrade very often, you should always have a choice of few 
kernels to decide on - you can simply decide to go with a less recent 
kernel that you've been testing for a while. 

And with a fairly short release cycle, even if you decide that "hey, we 
just don't know enough about the latest kernel, so let's go with the <n-1> 
release", you won't be _totally_ behind the times. Yeah, you'll be using 
something older, but it will be just two months older, not "totally 
ancient".

In other words, the fact that the kernel developers cut releases fairly 
often should mean that vendors can much more easily decide on their own 
release cycle _independently_ of the kernel release cycle, because at any 
point in time, you always have *some* kernel release that isn't horribly 
old, and that you can have a few months of knowledge about.

Compare that to a release cycle of every two years or something (eg a 
major gcc release), where if you're unlucky, you have the choice between 
"recent and all the features, but it's not seen a lot of testing yet", or 
"really quite old and stable, and we'll look bad for packaging it when 
people know there is a much more recent release".

In that kind of situation, a downstream vendor just doesn't have a lot of 
good choices: delay the release until you know more about the package, or 
ship a really old version, or ship a new and scary one. All three are "big 
choices", and you can just pray you do the right one.

In contrast, the kernel release cycle has been geared to making those 
choices "small and inconsequential". Right now, you can basically choose 
between any of 
 - 2.6.19.7
 - 2.6.20.10
 - 2.6.21.1
and none of them are horribly old, and you can base your choice on just 
how adventurous you are _and_ on being familiar with two of them.

For example, I think 2.6.20 was a good release, and so my gut feel is that 
2.6.20.10 is probably preferable over the 2.6.19-based one, but if you 
want to live on the edge, you'd pick 2.6.21.1, and if you want to go for 
having a _loong_ time of being comfy with something, you might decide to 
go with 2.6.16.49 that Adrian has been maintaining.

In other words, having tight development releases just makes all these 
choices easier. There's more choice, for sure, and that could feel scary, 
but at the same time, it should result in less of a "choice between two 
evils" kind of situation, and more of a "I *can* make an informed choice 
if I just spend some effort on it".

At least that was the plan. From everything I've heard, most people are 
pretty happy with the 2.6.x development model. You cannot please 
everybody, but the release frequency means that developers feel like they 
can work on relevant stuff all the time, and vendors can always choose 
something that is known stable and not horribly ancient.

			Linus
