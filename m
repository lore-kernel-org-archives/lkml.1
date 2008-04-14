Return-Path: <linux-kernel-owner+w=401wt.eu-S1760495AbYDNUZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760495AbYDNUZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 16:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbYDNUYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 16:24:53 -0400
Received: from mail.lang.hm ([64.81.33.126]:35144 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbYDNUYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 16:24:52 -0400
Date: Mon, 14 Apr 2008 13:29:29 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: Chris Mason <chris.mason@oracle.com>
cc: Christoph Hellwig <hch@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>, me@bobcopeland.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
In-Reply-To: <200804141020.37271.chris.mason@oracle.com>
Message-ID: <alpine.DEB.1.10.0804141326020.13255@asgard>
References: <20080412205544.5e12a7d4.akpm@linux-foundation.org> <20080414091639.4bd3879d@core> <20080414084141.GA29113@infradead.org> <200804141020.37271.chris.mason@oracle.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008, Chris Mason wrote:

> On Monday 14 April 2008, Christoph Hellwig wrote:
>> On Mon, Apr 14, 2008 at 09:16:39AM +0100, Alan Cox wrote:
>>> I think the exceed them quite easily. The costs are almost nil, while
>>> merging this provides another nice example fs (and one much easier to
>>> follow than ext*) for hardware that does have a few users and will no
>>> doubt get many more
>>>
>>> I wasn't aware Linus had introduced a new rule required 500 people sign
>>> up to use a feature before it gets added ?
>>
>> I'm also very surprised by this, especially as it seems to be applied
>> very selectively.  This filesystems is an almost 0 maintainance burden
>> unlike a lot of really crappy driver we're shoving in constantly.
>
> Thanks to Bob Copeland for taking the time to submit this for mainline.
> Please don't mistake the resulting debate as a sign we don't appreciate the
> effort of making it available and getting it reviewed.

seconded.

> Unlike all the device drivers we don't want floating around out of the tree,
> filesystem authors do have a choice between FUSE and being in-kernel.  Since
> OMFS has been maintained out of tree since 2.6.12 or so, Bob probably has a
> very good idea of how much time he has needed to spend updating things for
> each release.

switching to FUSE also has a cost for users, namely that they need to have 
FUSE setup (and the various interactions and deadlocks that can happen 
with a userspace filesystem, such as swapping to it)

as a user I would prefer to see filesystems (even ones I don't expect to 
uer) be all treated the same way, not have to figure out that to use this 
list of filesystems I configure them in the kernel, and to use that list 
of filesystem I have to run FUSE.

for testing, or for things that aren't really filesystems (views into 
version control systems, tarballs, etc) FUSE is a good match.

but for real filesystems it's a poor second.

David Lang

