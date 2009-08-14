Return-Path: <linux-kernel-owner+w=401wt.eu-S932691AbZHNQHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691AbZHNQHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 12:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932512AbZHNQHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 12:07:44 -0400
Received: from smtp.nokia.com ([192.100.122.230]:20011 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486AbZHNQHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 12:07:44 -0400
Message-ID: <4A858B4A.9000705@gmail.com>
Date: Fri, 14 Aug 2009 19:05:30 +0300
From: Artem Bityutskiy <dedekind1@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: JiSheng Zhang <jszhang3@gmail.com>
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Artem.Bityutskiy@nokia.com, adrian.hunter@nokia.com,
       rmk@arm.linux.org.uk, dwmw2@infradead.org
Subject: Re: [PATCH] UBI: Fix allocation of volume table
References: <20090811094455.6f9cbbfe@ustc>
In-Reply-To: <20090811094455.6f9cbbfe@ustc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 14 Aug 2009 16:07:19.0421 (UTC) FILETIME=[4CC9D2D0:01CA1CF9]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2009 04:44 AM, JiSheng Zhang wrote:
> We can't use vmalloc for the buffer used for volume table for some NAND
> or NOR drivers may pass the buffer to DMA. And the volume table size
> a.k.a vtbl_size is small so we can use kmalloc or kzalloc for it instead
>
> Signed-off-by: JiSheng Zhang<jszhang3@gmail.com>

I do not have objections if this patch becomes a member of a series of
patches which kick vmalloc from whole UBI. Applying just this patch does
not make much sense.

You may go through UBI code and try to split large vmalloc-ed buffers on
smaller kmalloc-ed ones.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
