Return-Path: <linux-kernel-owner+w=401wt.eu-S1763581AbYEOS3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763581AbYEOS3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757187AbYEOS3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:29:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:25472 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757152AbYEOS33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:29:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=K7GNQfUZTsONZFQVxyxfI2n6qL+1DCtH/y5Y+/ZjJJaQlIXy/8jVm22OKeP8uWNFQKz+FKcdba21jjT0BLBo0pD3YB3Pp3yUkxE8QS6YgtTJdKi3D1LRQNnQD2JUvNNIUflwqoAfPswYT8NIgW9ZSWzIrJxyuvvyZNWpjRZ2qBE=
Message-ID: <19f34abd0805151129j5e3de513s59875271fb4d9fab@mail.gmail.com>
Date: Thu, 15 May 2008 20:29:26 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Matthew Wilcox" <matthew@wil.cx>
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Rik van Riel" <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "Mel Gorman" <mel@skynet.ie>, mpm@selenic.com
In-Reply-To: <20080515174953.GN9921@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080510030919.604216074@sgi.com>
	 <20080510221515.3540a6cc@bree.surriel.com>
	 <2f11576a0805120038s334dc56cuaf16b8b7c6f87098@mail.gmail.com>
	 <84144f020805120054t1370236ei5ff52279457e026e@mail.gmail.com>
	 <Pine.LNX.4.64.0805141009210.15194@schroedinger.engr.sgi.com>
	 <482B2617.5010605@firstfloor.org>
	 <Pine.LNX.4.64.0805141100110.15633@schroedinger.engr.sgi.com>
	 <1210822002.3177.121.camel@ymzhang>
	 <Pine.LNX.4.64.0805151002420.18354@schroedinger.engr.sgi.com>
	 <20080515174953.GN9921@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 7:49 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Thu, May 15, 2008 at 10:05:35AM -0700, Christoph Lameter wrote:
>> Thanks for using the slab statistics. I wish I had these numbers for the
>> TPC benchmark. That would allow us to understand what is going on while it
>> is running.
>
> Hang on, you want slab statistics for the TPC run?  You didn't tell me
> that.  We're trying to gather oprofile data (and having trouble because
> the machine crashes when we start using oprofile -- this is with the git
> tree you/pekka put together for us to test).

Hi,

oprofile was recently fixed, maybe try cherry-picking these will help:

http://git.kernel.org/?p=linux/kernel/git/smurf/linux-trees.git;a=commit;h=7ded2dcf5f2c30889d7ac743ed64fff272ec190d
http://git.kernel.org/?p=linux/kernel/git/smurf/linux-trees.git;a=commit;h=08bc5caced1f322255f44880529a651e204a38eb
http://git.kernel.org/?p=linux/kernel/git/smurf/linux-trees.git;a=commit;h=2b56af59ed24d25be0282de9ae98c290e03a7dd9

Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
