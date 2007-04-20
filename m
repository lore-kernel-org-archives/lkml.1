Return-Path: <linux-kernel-owner+w=401wt.eu-S1751153AbXDTXOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751153AbXDTXOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 19:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbXDTXOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 19:14:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbXDTXOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 19:14:52 -0400
Message-ID: <46294967.6070601@redhat.com>
Date: Fri, 20 Apr 2007 18:14:47 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (Macintosh/20070221)
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ext4 development <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] fix ext2 allocator overflows above 31 bit blocks
References: <4628F3ED.9040101@redhat.com> <20070420230208.GU5967@schatzie.adilger.int>
In-Reply-To: <20070420230208.GU5967@schatzie.adilger.int>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Dilger wrote:
> On Apr 20, 2007  12:10 -0500, Eric Sandeen wrote:
>> If ext3 can do 16T, ext2 probably should be able to as well.
>> There are still "int" block containers in the block allocation path
>> that need to be fixed up.
> 
> Yeah, but who wants to do 16TB e2fsck on every boot?  I think there
> needs to be some limits imposed for the sake of usability.

I figure this is in the fine tradition of "enough rope to hang oneself"

If you have 16T of filesystem you probably know enough to not hang 
yourself this way.

*shrug*

It's a bug, today.   If we need another change to limit ext2 to 500G or 
something, fine by me.  :)

-Eric
