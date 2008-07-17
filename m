Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbYGQIAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbYGQIAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 04:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbYGQIAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 04:00:25 -0400
Received: from r00tworld.com ([212.85.137.21]:33402 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbYGQIAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 04:00:24 -0400
From: pageexec@freemail.hu
To: "Rafael C. de Almeida" <almeidaraf@gmail.com>
Date: Thu, 17 Jul 2008 09:59:10 +0200
MIME-Version: 1.0
Subject: Re: [stable] Linux 2.6.25.10
Reply-to: pageexec@freemail.hu
CC: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Message-ID: <487F17EE.5023.237EC55A@pageexec.freemail.hu>
In-reply-to: <487EF279.2050704@gmail.com>
References: <20080703185727.GA12617@suse.de>, <487D3056.1183.1C0E1C47@pageexec.freemail.hu>, <487EF279.2050704@gmail.com>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Thu, 17 Jul 2008 09:59:55 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 Jul 2008 at 4:19, Rafael C. de Almeida wrote:

> pageexec@freemail.hu wrote:
> > in other words, you should not be worrying about people not learning about
> > all security fixes, they already know it's not possible to provide such
> > information. however sharing your knowledge that you do have will *help*
> > them because 1. they can know for sure it's something important to apply
> > (no need to use their limited human resources to make that judgement),
> > 2. they can spend more of their resources on analyzing the *other* unmarked
> > fixes. overall this can only improve everyone's security.
> 
> Hey, I have a crazy idea! What if they just mark all the bugs as a
> security bug (after all they all kinda are for some definition of
> security anyway)? That way people just apply all the patches and do not
> have to analyze anything, therefore not wasting their limited human
> resources at all!
> 
> Linus' point is exactly that they shouldn't be treated differently,

yet they already are, see below.

> so you shouldn't allocate human resources to other bugs and just apply the
> security ones. If you want to convince someone you must tell us *why*
> those so-called security bugs are more important.

look at what went into 2.6.25.11 for example. it's a security fix. you do
treat them differently: you include them in -stable to the exclusion of
many other 'less important' fixes. read Documentation/stable_kernel_rules.txt
for how you not treat all fixes as equal (it's not only security ones that
are special cased).

> Also, you need to tell
> us what you consider to be a security bug. That's not clear to me at least.

anything that breaks the kernel's security model. privilege elevation
always does.

