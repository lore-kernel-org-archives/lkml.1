Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203AbZHXS16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbZHXS16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 14:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbZHXS15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 14:27:57 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:57654 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbZHXS14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 14:27:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dbzQkPMYnfPYNffGqGKPDltXMTgKuEA8g6gCxasZr03BXLcJS+L1d9xmMe0YoW9Onj
         CIWJJKbebPIfJmbDfEBx1Iir4/TvKyceDllo0zg61mNEnNwTA13R4lPk45heKp0TD+BZ
         BY2+NzycbLveLVOvz0ktY0PkU6kGQ6UKYg1Vo=
MIME-Version: 1.0
In-Reply-To: <4A92D7D4.7020807@vflare.org>
References: <200908241007.47910.ngupta@vflare.org>
	 <84144f020908241033l4af09e7h9caac47d8d9b7841@mail.gmail.com>
	 <4A92D35F.50604@vflare.org>
	 <84144f020908241108o4d9d6e38wba7806977b8b6073@mail.gmail.com>
	 <4A92D7D4.7020807@vflare.org>
Date: Mon, 24 Aug 2009 21:27:57 +0300
X-Google-Sender-Auth: 0d59b3509737a809
Message-ID: <84144f020908241127vc8dafa4l340d000097cf5548@mail.gmail.com>
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

On Mon, Aug 24, 2009 at 9:11 PM, Nitin Gupta<ngupta@vflare.org> wrote:
>> Is the name rzmalloc() too similar to kzalloc() which stands for
>> zeroing allocator, though? I think I suggested
>> ramzswap_alloc()/ramzswap_free() in the past to avoid confusion. I'd
>> rather go with that if we can't come up with a nice generic name that
>> stands for alloc_part_of_page_including_highmem().
>
> rzs_malloc()/rzs_free() ?

I am not sure what we gain from the shorter and more cryptic "rzs"
prefix compared to "ramzswap" but yeah, it's less likely to be
confused with kzalloc() so I'm okay with that.
