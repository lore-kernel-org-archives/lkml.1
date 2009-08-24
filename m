Return-Path: <linux-kernel-owner+w=401wt.eu-S1753196AbZHXSID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbZHXSID (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 14:08:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbZHXSIC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 14:08:02 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:43418 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbZHXSIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 14:08:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Ukoe8yghoHnHETRDvdjE9egWnK+ZSY1h/dsKC0lVlVt3thb8JrRF8bTSqWuVZK9Ik+
         IfOhm74+Nv3Hv0JTI7mCE7ZB+K11qmSVVG8g8pJbJ2Zy6mUrH/fJfpC1mBbJPLNO4F3U
         67hop1OOTnZlISC1zc1rVBxZ9EteqTr2QVg7s=
MIME-Version: 1.0
In-Reply-To: <4A92D35F.50604@vflare.org>
References: <200908241007.47910.ngupta@vflare.org>
	 <84144f020908241033l4af09e7h9caac47d8d9b7841@mail.gmail.com>
	 <4A92D35F.50604@vflare.org>
Date: Mon, 24 Aug 2009 21:08:01 +0300
X-Google-Sender-Auth: c1c2ab9bfb4ed89e
Message-ID: <84144f020908241108o4d9d6e38wba7806977b8b6073@mail.gmail.com>
Subject: Re: [PATCH 1/4] compcache: xvmalloc memory allocator
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: ngupta@vflare.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-mm-cc@laptop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nitin,

On Mon, Aug 24, 2009 at 8:52 PM, Nitin Gupta<ngupta@vflare.org> wrote:
> I am okay with renaming it to rzmalloc and compiling it with ramzswap
> instead of as separate module.

Is the name rzmalloc() too similar to kzalloc() which stands for
zeroing allocator, though? I think I suggested
ramzswap_alloc()/ramzswap_free() in the past to avoid confusion. I'd
rather go with that if we can't come up with a nice generic name that
stands for alloc_part_of_page_including_highmem().

                       Pekka
