Return-Path: <linux-kernel-owner+w=401wt.eu-S1755010AbZHCWVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbZHCWVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 18:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754997AbZHCWVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 18:21:31 -0400
Received: from sandeen.net ([209.173.210.139]:27245 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922AbZHCWVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 18:21:30 -0400
Message-ID: <4A7762EA.5070701@sandeen.net>
Date: Mon, 03 Aug 2009 17:21:30 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Eric Sandeen <sandeen@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs/compat_ioctl.c: add missing FS_IOC_FIEMAP support
References: <4A74584D.2010300@rtr.ca> <4A7722DF.80704@rtr.ca> <4A7725AF.6090106@redhat.com> <4A775FB9.80600@rtr.ca>
In-Reply-To: <4A775FB9.80600@rtr.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Eric Sandeen wrote:
>> Mark Lord wrote:
>>> (resending, no ack from anyone first time around).
>> I had previously sent a fix for this to the ext4 list as well, although
>> w/o the added case for compat_ioctl or the extra #include.
>>
>> Because this ioctl should be 100% compat everywhere, I don't -think-
>> it's needed, and
>>
>> http://marc.info/?l=linux-ext4&m=124872536713005&w=2
>>
>> suffices....
> ..
> 
> Well, whichever of the two works best for the maintainers.
> 
> We need *something* for it upstream, and probably back in -stable too.
> Otherwise this prevents using 64-bit kernels on 32-bit userland,
> as Linus likes to recommend so often.  ;)
> 
> Cheers
> 

Heh, it's probably far from the only ioctl missing a compat handler, but
yeah.  :)

-Eric
