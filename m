Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbZBSOYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbZBSOYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 09:24:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbZBSOYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 09:24:21 -0500
Received: from mail.tpi.com ([70.99.223.143]:1931 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726AbZBSOYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 09:24:21 -0500
Message-ID: <499D6B8F.9080107@canonical.com>
Date: Thu, 19 Feb 2009 07:24:15 -0700
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Ubuntu Jaunty ext3 --> ext4 upgrade issue
References: <499C4F1E.8050901@canonical.com> <20090218222517.GT3600@mini-me.lan>
In-Reply-To: <20090218222517.GT3600@mini-me.lan>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Wed, Feb 18, 2009 at 11:10:38AM -0700, Tim Gardner wrote:
>> I've encountered a situation where the patches that you've proposed for
>> stable updates might be causing some issues. This user ivoks appears to
>> have an upgrade issue. I assume he's enabled ext4 on an existing ext3
>> file system. Hopefully I can get more details. Have you seen anything
>> like this?
> 
> No, this is the first I've heard of it. 
> 
>> <ivoks> i'm getting 'Invalid or unsupported executable format' from grub
>> on all jaunty's generic kernels since (including) 2.6.28-7
> 
> So grub is complaining that it can't boot from a partition after
> upgrading to the new kernel with the for-stable patches?  Um, that's
> interesting.  So the obvious thing to check is to do an md5 checksum
> of the kernel in /boot to make sure it didn't get corrupted somehow.
> The other thing to check would be to ask the user to run e2fsck to
> rule out filesystem corruption.
> 
> OTOH, if this was just a simple install and upgrade, presumably the
> new kernel would have been installed while the previous kernel was
> booted.
> 
> I do my testing by using a ext3 /boot partition (since my
> crash-and-burn netbook is running Ubuntu Jaunty).  So I wouldn't have
> noticed anything, but this seems very odd.
> 
> More information would be useful; is there a Launchpad bug open on this yet?
> 
> Or we can work this out on LKML or the linux-ext4 mailing list if the
> reporter is willing to be cc'ed on the thread....
> 
>      		       	  	     	   - Ted
> 

Here is the initial report:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/331558

I'll produce a test kernel for the user that has _all_ of the proposed
stable patches from your ext4/for-stable branch (including the jbd2 stuff).

rtg
-- 
Tim Gardner tim.gardner@canonical.com
