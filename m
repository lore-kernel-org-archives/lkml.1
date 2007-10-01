Return-Path: <linux-kernel-owner+w=401wt.eu-S1755347AbXJAQGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347AbXJAQGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 12:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbXJAQFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 12:05:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38103 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751320AbXJAQFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 12:05:53 -0400
Date: Mon, 1 Oct 2007 09:04:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephen Smalley <sds@tycho.nsa.gov>
cc: James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access
 Control Kernel
In-Reply-To: <1191253239.7672.76.camel@moss-spartans.epoch.ncsc.mil>
Message-ID: <alpine.LFD.0.999.0710010854120.3579@woody.linux-foundation.org>
References: <46FEEBD4.5050401@schaufler-ca.com>  <20070930011618.ccb8351b.akpm@linux-foundation.org>
  <Xine.LNX.4.64.0710010146100.13671@us.intercode.com.au> 
 <alpine.LFD.0.999.0710010803280.3579@woody.linux-foundation.org>
 <1191253239.7672.76.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 1 Oct 2007, Stephen Smalley wrote:
> 
> You argued against pluggable schedulers, right?  Why is security
> different?

Schedulers can be objectively tested. There's this thing called 
"performance", that can generally be quantified on a load basis.

Yes, you can have crazy ideas in both schedulers and security. Yes, you 
can simplify both for a particular load. Yes, you can make mistakes in 
both. But the *discussion* on security seems to never get down to real 
numbers. 

So the difference between them is simple: one is "hard science". The other 
one is "people wanking around with their opinions".

If you guys had been able to argue on hard data and be in agreement, LSM 
wouldn't have been needed in the first place. 

	BUT THAT WAS NOT THE CASE.

And perhaps more importantly:

	BUT THAT IS *STILL* NOT THE CASE!

Sorry for the shouting, but I'm serious about this.

> Do you really want to encourage people to roll their own security module
> rather than working toward a common security architecture and a single
> balanced solution (which doesn't necessarily mean SELinux, mind you, but
> certainly could draw from parts of it)?   As with pluggable schedulers,
> the LSM approach prevents cross pollination and forces users to make
> poor choices.

Another difference is that when it comes to schedulers, I feel like I 
actually can make an informed decision. Which means that I'm perfectly 
happy to just make that decision, and take the flak that I get for it. And 
I do (both decide, and get flak). That's my job.

In contrast, when it comes to security, I see people making IDIOTIC 
arguments, and I absolutely *know* that those arguments are pure and utter 
crap, and at the same time, I see that those people are supposed to be 
"experts".

For example, you security guys still debate "inodes" vs "pathnames", as if 
that was an either-or issue.

Quite frankly, I'm not a security person, but I can tell a bad argument 
from a good one. And an argument that says "inodes _or_ pathnames" is so 
full of shit that it's not even funny. And a person who says that it has 
to be one or the other is incompetent.

Yet that is *still* the level of disagreement I see.

So LSM stays in. No ifs, buts, maybes or anything else.

When I see the security people making sane arguments and agreeing on 
something, that will change. Quite frankly, I expect hell to freeze over 
before that happens, and pigs will be nesting in trees. But hey, I can 
hope.

> If Smack is mergeable despite likely being nothing more than a strict
> subset of SELinux (MAC, label-based, should be easily emulated on top of
> SELinux or via fairly simple extension to it to make such emulation
> simpler or more optimal), then what isn't mergeable as a separate
> security module?

I'm simply not interested in this discussion. If you cannot understand the 
*meta*discussion above (which has nothing to do with SMACK or SELinux per 
se), I cannot help you.

The biggest reason for me to merge SMACK (and AppArmor) would not be those 
particular security modules in themselves, but to inject a sense of 
reality in people. Right now, I see discussions about removign LSM because 
"SELinux is everything". THAT IS A PROBLEM.

			Linus
