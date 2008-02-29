Return-Path: <linux-kernel-owner+w=401wt.eu-S933717AbYB2WuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933717AbYB2WuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 17:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760259AbYB2WuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 17:50:07 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:46673 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755119AbYB2WuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 17:50:05 -0500
Date: Fri, 29 Feb 2008 23:27:01 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Andrew Morton <akpm@linux-foundation.org>
cc: johnstul@us.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       rostedt@goodmis.org
Subject: Re: [PATCH] Remove obsolete CLOCK_TICK_ADJUST
In-Reply-To: <20080229140842.575e72aa.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0802292315480.2723@scrub.home>
References: <1201142334.6383.40.camel@localhost.localdomain>
 <Pine.LNX.4.64.0801290439480.17507@scrub.home> <1201659263.6766.40.camel@localhost>
 <Pine.LNX.4.64.0801310251090.17507@scrub.home> <1201745776.6195.14.camel@localhost.localdomain>
 <Pine.LNX.4.64.0801310404480.17507@scrub.home> <1201914175.6216.46.camel@jstultz-laptop>
 <Pine.LNX.4.64.0802081718040.3378@scrub.home> <1202523452.6174.45.camel@localhost.localdomain>
 <Pine.LNX.4.64.0802101917030.3378@scrub.home> <1202774999.5984.106.camel@localhost>
 <Pine.LNX.4.64.0802120335170.3378@scrub.home> <1202963796.6195.141.camel@localhost.localdomain>
 <Pine.LNX.4.64.0802150436300.1822@scrub.home> <1203382940.5984.242.camel@localhost>
 <Pine.LNX.4.64.0802190219360.2723@scrub.home> <1203472250.6123.98.camel@localhost>
 <Pine.LNX.4.64.0802200348230.2723@scrub.home> <1203647951.6150.80.camel@localhost.localdomain>
 <Pine.LNX.4.64.0802290547320.2723@scrub.home> <20080229140842.575e72aa.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 29 Feb 2008, Andrew Morton wrote:

> The changelog provides no reason for the revert of those two patches.
> 
> Look at it from the point of view of a person who hasn't been following the
> discussion (whose initials might be LT).  That person might get puzzled and
> upset, no?

I'm puzzled at how to explain this...
The whole details have been explained over and over during the discussion.
The simple answer is that CLOCK_TICK_ADJUST has been causing extra clock 
drift, John's attempt didn't fix the real cause.
My patch doesn't just revert the patches, it also includes the _real_ fix, 
so why would the real fix require more justification? That person also 
didn't get puzzled why two patches claiming to fix the same problem got 
merged...

bye, Roman
