Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549Ab0BPDSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 22:18:51 -0500
Received: from mail.lang.hm ([64.81.33.126]:42989 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932434Ab0BPDSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 22:18:50 -0500
Date: Mon, 15 Feb 2010 19:18:32 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Neil Brown <neilb@suse.de>, Michael Evans <mjevans1983@gmail.com>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Linux mdadm superblock question.
In-Reply-To: <4B79F3CE.5030907@zytor.com>
Message-ID: <alpine.DEB.2.00.1002151916280.5135@asgard.lang.hm>
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan> <4877c76c1002111752h23e14f7aibe58a89181e6f493@mail.gmail.com> <4B77044B.1020609@zytor.com> <20100216112708.4a863f86@notabene.brown> <4B79F3CE.5030907@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Feb 2010, H. Peter Anvin wrote:

> On 02/15/2010 04:27 PM, Neil Brown wrote:
>
> There are three options:
>
> a) either don't boot from it (separate /boot);
> b) use a bootloader which installs in the MBR and
> hopefully-unpartitioned disk areas (e.g. Grub);
> c) use a nonstandard custom MBR.
>
> Neither (b) or (c), of course, allow for chainloading from another OS
> install and thus are bad for interoperability.

I have had no problems with XFS partitions and lilo as the bootloader. 
I've been doing this for a couple of years now without realizing that 
there is supposed to be a problem.

David Lang
