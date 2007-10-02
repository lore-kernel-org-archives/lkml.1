Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbXJBU6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbXJBU6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 16:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755500AbXJBU6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 16:58:25 -0400
Received: from mail.tmr.com ([64.65.253.246]:36995 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755387AbXJBU6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 16:58:22 -0400
Message-ID: <4702B1D5.5050502@tmr.com>
Date: Tue, 02 Oct 2007 17:02:13 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.lsm,gmane.linux.kernel
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access
   Control Kernel
References: <46FEEBD4.5050401@schaufler-ca.com>  <20070930011618.ccb8351b.akpm@linux-foundation.org>  <Xine.LNX.4.64.0710010146100.13671@us.intercode.com.au>  <alpine.LFD.0.999.0710010803280.3579@woody.linux-foundation.org> <1191253239.7672.76.camel@moss-spartans.epoch.ncsc.mil> <alpine.LFD.0.999.0710010854120.3579@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710010854120.3579@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 1 Oct 2007, Stephen Smalley wrote:
>> You argued against pluggable schedulers, right?  Why is security
>> different?
> 
> Schedulers can be objectively tested. There's this thing called 
> "performance", that can generally be quantified on a load basis.
> 
> Yes, you can have crazy ideas in both schedulers and security. Yes, you 
> can simplify both for a particular load. Yes, you can make mistakes in 
> both. But the *discussion* on security seems to never get down to real 
> numbers. 
> 
And yet you can make the exact same case for schedulers as security, you 
can quantify the behavior, but if your only choice is A it doesn't help 
to know that B is better.

You say "performance" as if it had universal meaning. In truth people 
want to optimize for total tps (servers), or responsiveness on the human 
scale (mail, dns, nntp servers), or perceived smoothness (with many 
threads updating a display to slow with load rather than start visibly 
jumping the motion from one to another), or very short term response 
(-rt patches). People want very different behavior under the same load, 
and that is what *they* call "performance," namely best delivery of 
what's important. The numbers are "hard science" but the choice of which 
numbers are important is still "people wanking around with their opinions".

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
