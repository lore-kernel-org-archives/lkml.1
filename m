Return-Path: <linux-kernel-owner+w=401wt.eu-S933203AbYBUVPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933203AbYBUVPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 16:15:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754489AbYBUVPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 16:15:43 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59406 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753891AbYBUVPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 16:15:42 -0500
Date: Thu, 21 Feb 2008 13:14:55 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
cc: Roland Dreier <rdreier@cisco.com>, Glenn Streiff <gstreiff@NetEffect.com>,
       Faisal Latif <flatif@NetEffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: Merging of completely unreviewed drivers
In-Reply-To: <20080221210124.GD28328@cs181133002.pp.htv.fi>
Message-ID: <alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org>
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2> <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2> <20080221154951.GA28328@cs181133002.pp.htv.fi> <adahcg2awag.fsf@cisco.com> <20080221210124.GD28328@cs181133002.pp.htv.fi>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Feb 2008, Adrian Bunk wrote:
> 
> Is it really intended to merge drivers without _any_ kind of review?

I'd really rather have the driver merged, and then *other* people can send 
patches!

The thing is, that's what merging really means - people can work on it 
sanely together. Before it's merged, it's a lot harder for people to work 
on it unless they are really serious about that driver, so before 
merging, the janitorial kind of things seldom happen.

So yes, I really do believe that we should merge drivers in particular a 
lot more aggressively. I'd like to see *testing* feedback, in order to not 
merge drivers that simply don't work well enough, but anything else? I 
suspect other feedback is as likely to cause problems as it is to fix 
things.

> This driver even lacks a basic "please fix the > 250 checkpatch errors" [1]
> and similar low hanging fruits that could easily be spotted and then 
> fixed by the submitter within a short amount of time.

Quite frankly, I've several times been *this* close (holds up fingers so 
you can't even see between them) to just remove checkpatch entirely.

I'm personally of the opinion that a lot of checkpatch "fixes" are 
anything but. That mainly concerns fixing overlong lines (where the 
"fixed" version is usually worse than the original), but it's been true 
for some other warnings too.

		Linus
