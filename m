Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab0CDP3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 10:29:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53518 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754880Ab0CDP3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 10:29:50 -0500
Message-ID: <4B8FD1C8.6040203@zytor.com>
Date: Thu, 04 Mar 2010 07:29:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: Daniel Taylor <Daniel.Taylor@wdc.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] msdos: add support for large disks
References: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD2D@wdscexbe01.sc.wdc.com>	<20100301141335.395dc4c3.akpm@linux-foundation.org>	<873a0h1p2c.fsf@devron.myhome.or.jp>	<3E0C3AE547FA504DA5E89EA5A24AC85803E2BD53@wdscexbe01.sc.wdc.com>	<4B8EEB2D.4090106@zytor.com>	<3E0C3AE547FA504DA5E89EA5A24AC85803E2BD56@wdscexbe01.sc.wdc.com> <871vg0zbqe.fsf@devron.myhome.or.jp>
In-Reply-To: <871vg0zbqe.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2010 01:18 AM, OGAWA Hirofumi wrote:
> "Daniel Taylor"<Daniel.Taylor@wdc.com>  writes:
>
>> It is only the intermediate variables in the module that are
>> currently hard-coded to 32-bits, and which truncate the values.
>
> BTW, it may not be only 32-bits truncate issue. IIRC, e.g. some
> implement is checking the 0xaa mark at the end of sector. I forgot
> almost though, IIRC, Windows writes 0xaa mark to the both of "end of
> sector" and "end of 512" for compatibility.
>
> Thanks.

The spec is that the mark, partition table etc. at the end of 512 bytes; 
of course, a lot of people go that wrong.

	-hpa
