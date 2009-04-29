Return-Path: <linux-kernel-owner+w=401wt.eu-S1757066AbZD2PjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066AbZD2PjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 11:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754293AbZD2PjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 11:39:03 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:45813 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbZD2PjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 11:39:01 -0400
Message-ID: <49F87490.5090401@linux.vnet.ibm.com>
Date: Wed, 29 Apr 2009 10:38:56 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: origin tree build warnings
References: <20090429144436.e821c0f1.sfr@canb.auug.org.au> <20090429005210.3dd9166e.akpm@linux-foundation.org>
In-Reply-To: <20090429005210.3dd9166e.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
OpenPGP: id=5D35E502
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 29 Apr 2009 14:44:36 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
>> Hi Tyler,
>>
>> Today's linux-next build (x86_64 allmodconfig) generated these warnings:
>>
>> fs/ecryptfs/inode.c: In function 'ecryptfs_readlink':
>> fs/ecryptfs/inode.c:670: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'
>> fs/ecryptfs/inode.c:693: warning: comparison of distinct pointer types lacks a cast
>>
>> Caused by commit 3a6b42cadc112b01daf0525e5fcd90bb333a5bb3 ("eCryptfs:
>> Larger buffer for encrypted symlink targets").
> 
> yup, Randy sent a fix for this today.
> 
> I merged that patch and put it into my "to be merged into 2.6.30 via
> the ecryptfs tree" pile.
> 
> Tyler, if you can't be bothered setting up a git pull for a one-liner
> then feel free to tell me to merge it.
> 
> If you don't do that then I tend to end up sitting on the patch for
> rather a while, sending it at the tree maintainer once every couple of
> weeks.  Sometimes I end up sitting on them after the major kernel
> release, after having sent them to the maintainer several times, which
> is all very sad.  Sometimes I'll get bored of sending them at the
> maintainer and I'll just merge them anyway, depending upon how frisky
> I'm feeling.

Hi Andrew - I see another warning in Stephen's email that should be
addressed, too.  I'll fix that and set up a git pull containing both
fixes a little later today.

Tyler
