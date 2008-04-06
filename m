Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbYDFPhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbYDFPhq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 11:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbYDFPhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 11:37:37 -0400
Received: from brick.kernel.dk ([87.55.233.238]:20490 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278AbYDFPhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 11:37:36 -0400
Date: Sun, 6 Apr 2008 17:37:30 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Peter Teoh <htmldeveloper@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       "kernelnewbies@nl.linux.org" <kernelnewbies@nl.linux.org>
Subject: Re: blktrace debugging:   how to use it
Message-ID: <20080406153728.GU12774@kernel.dk>
References: <47F0418C.8080407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47F0418C.8080407@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31 2008, Peter Teoh wrote:
> The is patch is to enable blktrace debugging in the kernel:
> 
> http://lkml.org/lkml/2006/8/1/405
> 
> Can anyone provide any guidelines or references on how to use this 
> feature from userspace?   Any tools written to TEST and use this feature?

Just git clone the repo:

git://git.kernel.dk/blktrace.git

(which is mentioned in the Kconfig help entry for that kernel config
option)

or grab the latest snapshot here:

http://brick.kernel.dk/snaps/blktrace-git-latest.tar.gz

it comes with documentation and man pages (mostly thanks to others than
myself :-) and also a nifty btt tool that can do lots of things that
blkparse cannot.

-- 
Jens Axboe

