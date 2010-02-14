Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab0BODUI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 22:20:08 -0500
Received: from tritonia.xxlwebhosting.nl ([81.4.88.63]:40993 "EHLO
	tritonia.xxlwebhosting.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab0BODUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 22:20:06 -0500
X-Greylist: delayed 14391 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Feb 2010 22:20:06 EST
Message-ID: <4B788525.6000608@grumpydevil.homelinux.org>
Date: Mon, 15 Feb 2010 00:20:05 +0100
From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090820)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Asdo <asdo@shiftmail.org>, Justin Piszcz <jpiszcz@lucidpixels.com>,
       Michael Evans <mjevans1983@gmail.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Linux mdadm superblock question.
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan> <4877c76c1002111752h23e14f7aibe58a89181e6f493@mail.gmail.com> <4B77044B.1020609@zytor.com> <alpine.DEB.2.00.1002131507260.31103@p34.internal.lan> <4B7719C1.1060400@zytor.com> <4B785C49.7010105@shiftmail.org> <4B786898.8030309@zytor.com>
In-Reply-To: <4B786898.8030309@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - tritonia.xxlwebhosting.nl
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - grumpydevil.homelinux.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> In Fedora 12, for example, Dracut tries to make the distinction between
> whole RAID device and a partition device, and utterly fails -- often
> resulting in data loss.
>
>   
i do not use Fedora/redhat and do not intent to ever try them again... 
still, the point is valid
> With a pointer to the beginning this would have been a trivial thing to
> detect.
>
> IMO it would make sense to support autoassemble for 1.0 superblocks, and
> making them the default.  The purpose would be to get everyone off 0.9.
>  However, *any* default is better than 1.1.
>
> 	-hpa
>
>   
As long is autodetect is supported in the kernel, i am willing to 
upgrade to 1.0 superblocks. BUT i need the autodetect in the kernel, as 
i refuse to use initrd for production servers.

Cheers,


Rudy

