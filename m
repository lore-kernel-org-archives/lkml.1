Return-Path: <linux-kernel-owner+w=401wt.eu-S1030991AbXDWFrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030991AbXDWFrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 01:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030990AbXDWFra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 01:47:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34045 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030989AbXDWFrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 01:47:20 -0400
Message-ID: <462C4858.3050006@redhat.com>
Date: Mon, 23 Apr 2007 01:47:04 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: William Heimbigner <icxcnika@mar.tar.cc>
CC: Eric Hopper <hopper@omnifarious.org>, linux-kernel@vger.kernel.org
Subject: Re: Question about Reiser4
References: <20070423020046.GA28477@omnifarious.org> <462C2E5B.1080008@redhat.com> <Pine.LNX.4.64.0704230353000.25153@server.thyself>
In-Reply-To: <Pine.LNX.4.64.0704230353000.25153@server.thyself>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Heimbigner wrote:
>> Eric Hopper wrote:
>>>  I know that this whole effort has been put in disarray by the
>>>  prosecution of Hans Reiser, but I'm curious as to its status. 
>>
>> It was in disarray well before.  Many of the reiser4 features,
>> like filesystem plugins, make more technical sense in the Linux
>> VFS, but made more business sense for Namesys as a reiserfs 4
>> thing.  That lead to a stalemate.
>>
> Shouldn't it be a matter of stability though? 

A lot of other things matter.  Things like a willingness to
maintain the code after it gets merged, or at least turning
the code into something the community is willing to maintain
if the original developers stop maintaining it.

> Benchmarks suggest that 
> reiser4 is a good file system; reiser4 is the successor to the 
> already-accepted reiserfs; we've got experimental ext4 support but no 
> reiser4 support, etc.

Namesys kind of abandoned reiserfs after work on reiser4
started.  Taking in a new code base on such a track record
is not a good idea when the code is not in a shape where
the community wants to maintain it.

> I don't see why something like plugins should matter. If it works enough 
> to be marked as experimental, why shouldn't reiser4 support be included?
> It's a pain for me personally to have to patch any kernel with reiser4 
> support so I can use the reiser4 fs.

You basically have three options:

1) keep patching every time you upgrade the kernel

2) use another filesystem

3) become the new reiser4 maintainer and turn the code
    into something that Linus is willing to accept

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
