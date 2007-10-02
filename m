Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbXJBX1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbXJBX1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 19:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbXJBX0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 19:26:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58042 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752357AbXJBX0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 19:26:51 -0400
Date: Tue, 2 Oct 2007 16:25:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bill Davidsen <davidsen@tmr.com>
cc: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access
   Control Kernel
In-Reply-To: <alpine.LFD.0.999.0710021410470.3579@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0710021615520.3579@woody.linux-foundation.org>
References: <46FEEBD4.5050401@schaufler-ca.com>  <20070930011618.ccb8351b.akpm@linux-foundation.org>
  <Xine.LNX.4.64.0710010146100.13671@us.intercode.com.au> 
 <alpine.LFD.0.999.0710010803280.3579@woody.linux-foundation.org>
 <1191253239.7672.76.camel@moss-spartans.epoch.ncsc.mil>
 <alpine.LFD.0.999.0710010854120.3579@woody.linux-foundation.org>
 <4702B1D5.5050502@tmr.com>
 <alpine.LFD.0.999.0710021410470.3579@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Oct 2007, Linus Torvalds wrote:
> 
> I don't know who came up with it, or why people continue to feed the 
> insane ideas. Why do people think that servers don't care about latency? 
> Why do people believe that desktop doesn't have multiple processors or 
> through-put intensive loads? Why are people continuing this *idiotic* 
> scheduler discussion?

Btw, one thing that is true: while both servers and desktop cares about 
latency, it's often easier to *see* the issues on the desktop (or hear 
them: audio skipping).

But that doesn't mean that the server people wouldn't care, and it doesn't 
mean that scheduling would be "fundamentally different" on servers or the
desktop.

In contrast, security really *is* fundamentally different in different 
situations. For example, I find SELinux to be so irrelevant to my usage 
that I don't use it at all. I just don't have any other users on my 
machine, so the security I care about is in firewalls etc. And that really 
*is* fundamentally different from a system that has shell access to its 
users. Which in turn is fundamentally different from one that has some 
legal reasons why it needs to have a particular kind of security. Which in 
turn is fundamentally different from ....

You get the idea.

It boils down to: "scheduling is scheduling", and doesn't really change 
apart from the kind of decisions that are required by any scheduler (ie RT 
vs non-RT etc). Everybody wants the same thing in the end: low latency for 
loads where that matters, high bandwidth for loads where that matters. 
It's not a "one user has only one kind of load". Not at all.

Security, on the other hand, very much does depend on the circumstances 
and the wishes of the users (or policy-makers). And if we had one module 
that everybody would be happy with, I'd not make it pluggable either. But 
as it is, we _know_ that's not the case. 

		Linus
