Return-Path: <linux-kernel-owner+w=401wt.eu-S1762890AbYGOVUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762890AbYGOVUv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbYGOVUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:20:40 -0400
Received: from r00tworld.com ([212.85.137.21]:41716 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbYGOVUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:20:40 -0400
From: pageexec@freemail.hu
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 15 Jul 2008 23:18:46 +0200
MIME-Version: 1.0
Subject: Re: [stable] Linux 2.6.25.10
Reply-to: pageexec@freemail.hu
CC: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Message-ID: <487D3056.1183.1C0E1C47@pageexec.freemail.hu>
In-reply-to: <alpine.LFD.1.10.0807151331110.2867@woody.linux-foundation.org>
References: <20080703185727.GA12617@suse.de>, <487D2371.10258.1BDBBC00@pageexec.freemail.hu>, <alpine.LFD.1.10.0807151331110.2867@woody.linux-foundation.org>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Tue, 15 Jul 2008 23:19:30 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 Jul 2008 at 13:42, Linus Torvalds wrote:

> On Tue, 15 Jul 2008, pageexec@freemail.hu wrote:
> > 
> > i understand and i think noone expects that. in fact, i know how much
> > expertise and time it takes to determine that. but what happens when
> > you do figure out the security relevance of a bug during bug submission
> 
> The issue is that I think it's then _misleading_ to mark that kind of 
> commit specially, when I actually believe that it's in the minority.
> 
> If people think that they are safer for only applying (or upgrading to) 
> certain patches that are marked as being security-specific, they are 
> missing all the ones that weren't marked as such.

and how is that different from today's situation where they aren't told
at all? in other words, they already learned to live with that risk. if
you tell them about a security bug, they will build that knowledge into
their risk assessment process (which is what security is all about in
the end). anything you omit will skew their decision making process (in
particular, expose them to exploits if they fail to apply a fix because
they make a bad judgement call).

in other words, you should not be worrying about people not learning about
all security fixes, they already know it's not possible to provide such
information. however sharing your knowledge that you do have will *help*
them because 1. they can know for sure it's something important to apply
(no need to use their limited human resources to make that judgement),
2. they can spend more of their resources on analyzing the *other* unmarked
fixes. overall this can only improve everyone's security.

what you're afraid of is that people will take your 'we mark security
fixes we learn about' as 'we mark ALL security fixes that are such'. well,
make that very clear in a public document (Documentation/SecurityBugs is
a good place) and that's it, people will know you're doing a best effort
disclosure and not more.

cheers,
  PaX Team

