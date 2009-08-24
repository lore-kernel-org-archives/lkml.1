Return-Path: <linux-kernel-owner+w=401wt.eu-S1753160AbZHXRxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbZHXRxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 13:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbZHXRxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 13:53:05 -0400
Received: from mail-px0-f196.google.com ([209.85.216.196]:46691 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbZHXRxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 13:53:04 -0400
Message-ID: <4A92D35F.50604@vflare.org>
Date: Mon, 24 Aug 2009 23:22:31 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-mm-cc@laptop.org
Subject: Re: [PATCH 1/4] compcache: xvmalloc memory allocator
References: <200908241007.47910.ngupta@vflare.org> <84144f020908241033l4af09e7h9caac47d8d9b7841@mail.gmail.com>
In-Reply-To: <84144f020908241033l4af09e7h9caac47d8d9b7841@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

On 08/24/2009 11:03 PM, Pekka Enberg wrote:
>
> [ Nit: the name xmalloc() is usually reserved for non-failing allocators in
>    user-space which is why xvmalloc() looks so confusing to me. Can we
>    get a better name for the thing? Also, I'm not sure why xvmalloc is a
>    separate module. Can't you just make it in-kernel or compile it in to the
>    ramzswap module? ]
>

xvmalloc is still a separate module to make sure I do not make it ramzswap
specific.

I am okay with renaming it to rzmalloc and compiling it with ramzswap instead
of as separate module. I will make these changes in next revision of these
patches.

Thanks,
Nitin


