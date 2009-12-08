Return-Path: <linux-kernel-owner+w=401wt.eu-S1751317AbZLHI5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317AbZLHI5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 03:57:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbZLHI5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 03:57:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:58749 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbZLHI5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 03:57:14 -0500
Message-ID: <4B1E1513.3020000@kernel.org>
Date: Tue, 08 Dec 2009 17:57:55 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: tony.luck@intel.com, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmalloc: don't use vmalloc_end
References: <4B1D3A3302000078000241CD@vpn.id2.novell.com> <20091207153552.0fadf335.akpm@linux-foundation.org> <4B1E1B1B0200007800024345@vpn.id2.novell.com> <4B1E0E56.8020003@kernel.org> <4B1E1EE60200007800024364@vpn.id2.novell.com>
In-Reply-To: <4B1E1EE60200007800024364@vpn.id2.novell.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/08/2009 05:39 PM, Jan Beulich wrote:
>>>> Tejun Heo <tj@kernel.org> 08.12.09 09:29 >>>
>> Hmm... it shouldn't be building.
> 
> How can it not be building? It's in vmalloc.c (which must be built) and not
> inside any conditional.

Ah... yes, right.  Somehow I was thinking it lived in percpu.c.  Sorry
about that.  Probably the right thing to do is to wrap the function
inside CONFIG ifdef's.  I'll prep a patch.

Thanks.

-- 
tejun
