Return-Path: <linux-kernel-owner+w=401wt.eu-S932288AbZHCWH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288AbZHCWH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 18:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbZHCWHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 18:07:55 -0400
Received: from rtr.ca ([76.10.145.34]:44833 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804AbZHCWHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 18:07:55 -0400
Message-ID: <4A775FB9.80600@rtr.ca>
Date: Mon, 03 Aug 2009 18:07:53 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
       Eric Sandeen <sandeen@sandeen.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs/compat_ioctl.c: add missing FS_IOC_FIEMAP support
References: <4A74584D.2010300@rtr.ca> <4A7722DF.80704@rtr.ca> <4A7725AF.6090106@redhat.com>
In-Reply-To: <4A7725AF.6090106@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:
> Mark Lord wrote:
>> (resending, no ack from anyone first time around).
> 
> I had previously sent a fix for this to the ext4 list as well, although
> w/o the added case for compat_ioctl or the extra #include.
> 
> Because this ioctl should be 100% compat everywhere, I don't -think-
> it's needed, and
> 
> http://marc.info/?l=linux-ext4&m=124872536713005&w=2
> 
> suffices....
..

Well, whichever of the two works best for the maintainers.

We need *something* for it upstream, and probably back in -stable too.
Otherwise this prevents using 64-bit kernels on 32-bit userland,
as Linus likes to recommend so often.  ;)

Cheers
