Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966832Ab0B0B2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 20:28:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966806Ab0B0B2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 20:28:47 -0500
Message-ID: <4B887548.50508@redhat.com>
Date: Fri, 26 Feb 2010 19:28:40 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Piszcz <ap@solarrain.com>
Subject: Re: EXT4 is ~2X as slow as XFS (593MB/s vs 304MB/s) for writes?
References: <alpine.DEB.2.00.1002261922010.8247@p34.internal.lan> <4B886CA1.9050906@redhat.com> <alpine.DEB.2.00.1002262006000.8247@p34.internal.lan> <4B887160.2090606@redhat.com>
In-Reply-To: <4B887160.2090606@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:
> Justin Piszcz wrote:
> ...
> 
>>> Were the filesystems created to align with raid geometry?
>> Only default options were used except the mount options.  If that is the
>> culprit, I have some more testing to do, thanks, will look into it.
>>
>>> mkfs.xfs has done that forever; mkfs.ext4 only will do so (automatically)
>>> with recent kernel+e2fsprogs.
>> How recent?
> 
> You're recent enough.  :)

Oh, you need very recent util-linux-ng as well, and use libblkid from there
with:

[e2fsprogs] # ./configure --disable-libblkid

Otherwise you can just feed mkfs.ext4 stripe & stride manually.

-Eric
