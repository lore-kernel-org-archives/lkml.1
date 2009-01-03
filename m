Return-Path: <linux-kernel-owner+w=401wt.eu-S932732AbZACURc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732AbZACURc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 15:17:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759673AbZACURY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 15:17:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40895 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759614AbZACURX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 15:17:23 -0500
Date: Sat, 3 Jan 2009 12:16:50 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Gabor MICSKO <gmicsko@gmail.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Grsecurity is about to be discontinued, unless...
In-Reply-To: <1231013176.6497.20.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0901031210260.3179@localhost.localdomain>
References: <1231013176.6497.20.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 3 Jan 2009, Gabor MICSKO wrote:
> 
> In short, I would like to know what is your answer to this request. And
> in the case if you see no chance for the integration, I would like to
> know what is the reason behind this decision.

Quite frankly, historically the patches have been a mis-match of

 - some sane stuff

 - lots of totally insane and very annoying and invasive code.

an example of the second class is the totally idiotic "emulate NX bit - 
badly - with code segment limits" kind of patches. These kinds of patches 
only add unmaintainable crap that isn't even relevant in the long run, and 
thus any sane maintainer (me) should refuse to take them.

The apparent inability (and perhaps more importantly - total 
unwillingless) from the PaX team to be able to see what makes sense in a 
long-term general kernel and what does not, and split things up and try to 
push the sensible things up (and know which things are too ugly or too 
specialized to make sense), caused many PaX features to never be merged.

Much of it did get merged over the years (mostly because some people spent 
the time to separate things out), but no, we're not going to suddenly 
start merging code like that just because the project is in trouble. None 
of the basic issues have been solved.

			Linus
