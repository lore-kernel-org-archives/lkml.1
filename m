Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbZHXSMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbZHXSMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 14:12:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbZHXSME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 14:12:04 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:24722 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200AbZHXSMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 14:12:03 -0400
Message-ID: <4A92D7D4.7020807@vflare.org>
Date: Mon, 24 Aug 2009 23:41:32 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-mm-cc@laptop.org
Subject: Re: [PATCH 1/4] compcache: xvmalloc memory allocator
References: <200908241007.47910.ngupta@vflare.org>	 <84144f020908241033l4af09e7h9caac47d8d9b7841@mail.gmail.com>	 <4A92D35F.50604@vflare.org> <84144f020908241108o4d9d6e38wba7806977b8b6073@mail.gmail.com>
In-Reply-To: <84144f020908241108o4d9d6e38wba7806977b8b6073@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2009 11:38 PM, Pekka Enberg wrote:
> Hi Nitin,
>
> On Mon, Aug 24, 2009 at 8:52 PM, Nitin Gupta<ngupta@vflare.org>  wrote:
>> I am okay with renaming it to rzmalloc and compiling it with ramzswap
>> instead of as separate module.
>
> Is the name rzmalloc() too similar to kzalloc() which stands for
> zeroing allocator, though? I think I suggested
> ramzswap_alloc()/ramzswap_free() in the past to avoid confusion. I'd
> rather go with that if we can't come up with a nice generic name that
> stands for alloc_part_of_page_including_highmem().
>

rzs_malloc()/rzs_free() ?

Nitin
