Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102Ab0AHVoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab0AHVoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 16:44:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898Ab0AHVoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 16:44:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52389 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab0AHVoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 16:44:04 -0500
Message-ID: <4B47A713.9060405@zytor.com>
Date: Fri, 08 Jan 2010 13:43:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Karel Zak <kzak@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng v2.17 (stable)
References: <20100108093302.GS1969@nb.net.home>
In-Reply-To: <20100108093302.GS1969@nb.net.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2010 01:33 AM, Karel Zak wrote:
> 
> fdisk:
>    - the fdisk command aligns newly created partitions to minimum_io_size
>      boundary ("minimum_io_size" is physical sector size or stripe chunk
>      size on RAIDs).
> 
>    - the fdisk command supports disks with alignment_offset now.
> 

I think we should align, by default, much more aggressively than that --
because frequently we just don't know what the real physical alignment
is (think of flash media, which uses large erase blocks underneath.)
Windows aligns partitions 1 MB boundaries by default now -- I think
that's probably a reasonably good idea, at least for any disk that's not
tiny, say 256 MB or less.

	-hpa
