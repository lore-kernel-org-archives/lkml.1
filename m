Return-Path: <linux-kernel-owner+w=401wt.eu-S1760963AbXFRQQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760963AbXFRQQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 12:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758474AbXFRQQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 12:16:37 -0400
Received: from 216-99-213-120.dsl.aracnet.com ([216.99.213.120]:34037 "EHLO
	clueserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757048AbXFRQQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 12:16:35 -0400
Date: Mon, 18 Jun 2007 09:16:30 -0700 (PDT)
From: alan <alan@clueserver.org>
X-X-Sender: alan@blackbox.fnordora.org
To: Theodore Tso <tytso@mit.edu>
cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
In-Reply-To: <20070618140143.GD30244@thunk.org>
Message-ID: <Pine.LNX.4.64.0706180907580.22137@blackbox.fnordora.org>
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <467314E2.9010306@zytor.com>
 <Pine.LNX.4.64.0706151547200.27993@blackbox.fnordora.org>
 <20070616145337.GA13391@lazybastard.org> <20070618094524.GF5181@schatzie.adilger.int>
 <20070618140143.GD30244@thunk.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007, Theodore Tso wrote:

> On Mon, Jun 18, 2007 at 03:45:24AM -0600, Andreas Dilger wrote:
>> Too bad everyone is spending time on 10 similar-but-slightly-different
>> filesystems.  This will likely end up with a bunch of filesystems that
>> implement some easy subset of features, but will not get polished for
>> users or have a full set of features implemented (e.g. ACL, quota, fsck,
>> etc).  While I don't think there is a single answer to every question,
>> it does seem that the number of filesystem projects has climbed lately.
>
> I view some of the attempts for "from scratch" filesystems as ways of
> testing out various designs as "proof-of-concepts".  It's a great way
> of demo'ing ones ideas, to see how well they work.  There is a huge
> chasm between a proof-of-concept and a full production filesystem that
> has great repair/recovery tools, etc.  That's why it's so important to
> do the POC implementation first, so folks can see how well it works
> before investing a huge amount of effort to make it be
> production-ready.
>

I just wish that people would learn from the mistakes of others.  The 
MacOS is a prime example of why you do not want to use a forked 
filesystem, yet some people still seem to think it is a good idea. 
(Forked filesystems tend to be fragile and do not play well with 
non-forked filesystems.)

> So I actually think the number of these new filesystem proposals are
> *good* things.  It means people are interested in creating new
> filesystems, and that's all good.  Eventually, we'll need to decide
> which design ideas should be combined, and that may be a little tough
> to the egos involved, but that's all part of the darwinian kernel
> programming model.  Not all implementations make it into the kernel
> mainline.  That doesn't mean that the work that was done on the
> various schedular proposals were useless; they just helped demonstrate
> concepts and advanced the debate.

I would like to see more clarification from the designers as to what 
problem they are trying to solve.  Some of the goals seem to be laudable, 
but some are not problems that I worry about.

I see filesystems that are trying to handle the flakeyness of hardware. 
That is useful to me.  I also see people who are trying to archive every 
little change for "legal reasons".  I have a hard time with this one 
because I have a hard enough time keeping spare hard drive space for the 
stuff I want, not the space that someone else wants me to keep.

What I really want are high throughput systems where I can write and read 
as fast as the hardware will allow.  (And then I want faster hardware.)

-- 
"ANSI C says access to the padding fields of a struct is undefined.
ANSI C also says that struct assignment is a memcpy. Therefore struct
assignment in ANSI C is a violation of ANSI C..."
                                   - Alan Cox
