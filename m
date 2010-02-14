Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab0BNVSk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 16:18:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59856 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041Ab0BNVSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 16:18:38 -0500
Message-ID: <4B786898.8030309@zytor.com>
Date: Sun, 14 Feb 2010 13:18:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Asdo <asdo@shiftmail.org>
CC: Justin Piszcz <jpiszcz@lucidpixels.com>,
       Michael Evans <mjevans1983@gmail.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Linux mdadm superblock question.
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan> <4877c76c1002111752h23e14f7aibe58a89181e6f493@mail.gmail.com> <4B77044B.1020609@zytor.com> <alpine.DEB.2.00.1002131507260.31103@p34.internal.lan> <4B7719C1.1060400@zytor.com> <4B785C49.7010105@shiftmail.org>
In-Reply-To: <4B785C49.7010105@shiftmail.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2010 12:25 PM, Asdo wrote:
> I don't understand...
> In a system we have, the root filesystem on a raid-6 which is on second
> (and last) partitions of many disks.
> It always assembled correctly, it never tried to assemble the whole device.
> (on the first partition there is a raid1 with boot)
> So what's the problem exactly with not marking the beginning?

In Fedora 12, for example, Dracut tries to make the distinction between
whole RAID device and a partition device, and utterly fails -- often
resulting in data loss.

With a pointer to the beginning this would have been a trivial thing to
detect.

IMO it would make sense to support autoassemble for 1.0 superblocks, and
making them the default.  The purpose would be to get everyone off 0.9.
 However, *any* default is better than 1.1.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

