Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab0CHAMu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 19:12:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36022 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685Ab0CHAMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 19:12:49 -0500
Message-ID: <4B9440FC.3090502@zytor.com>
Date: Sun, 07 Mar 2010 16:12:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] msdos: add support for large disks
References: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD2D@wdscexbe01.sc.wdc.com>	<20100301141335.395dc4c3.akpm@linux-foundation.org>	<873a0h1p2c.fsf@devron.myhome.or.jp>	<876358iehd.fsf@devron.myhome.or.jp> <4B9430B6.701@zytor.com> <87pr3fd68r.fsf@devron.myhome.or.jp>
In-Reply-To: <87pr3fd68r.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2010 04:09 PM, OGAWA Hirofumi wrote:
>
> It means,
>
> 	min(size, max(logical_sector_size / 512, 2));
>
> or like this? ("size" is "nr_sects(part) * (logical_sector_size/512)")
>
> This should keep old logic, i.e. if partition is bigger than 1kb, it
> uses 1kb for (probably) LILO mentioned by comment.
>

I don't really know where the 1K cames from, and it isn't necessarily 
safe, either.

	-hpa
