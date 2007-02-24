Return-Path: <linux-kernel-owner+w=401wt.eu-S1752269AbXBXMmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269AbXBXMmZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 07:42:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932353AbXBXMmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 07:42:25 -0500
Received: from brick.kernel.dk ([62.242.22.158]:25911 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269AbXBXMmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 07:42:25 -0500
Date: Sat, 24 Feb 2007 13:42:06 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: V P <upathiyayan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: REQ_HARDBARRIER and REQ_SOFTBARRIER
Message-ID: <20070224124206.GG22586@kernel.dk>
References: <c9ad85600702240156g717d49cfm9c7ea30c00d48d28@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9ad85600702240156g717d49cfm9c7ea30c00d48d28@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 24 2007, V P wrote:
> Hi,
> 
> I'm trying to modify the ordering of I/O requests in Linux kernel, and
> came across the barrier flags REQ_HARDBARRIER and REQ_SOFTBARRIER.
> 
> One thing I noticed (which might be wrong) is that all the requests
> have both these flags set. What is the significance of these flags? Is

Uhm? That's definitely not true.

> it a must for a request to have this? Can I reorder two requests with
> these flags set? How is SOFTBARRIER different from HARDBARRIER?

Both imply a reordering barrier in the io scheduler, and the hard
barrier further implies a barrier at the drive/driver side. So you may
not reorder across a barrier.

-- 
Jens Axboe

