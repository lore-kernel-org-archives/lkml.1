Return-Path: <linux-kernel-owner+w=401wt.eu-S1754579AbZLHI2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbZLHI2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 03:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbZLHI2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 03:28:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:57206 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323AbZLHI2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 03:28:49 -0500
Message-ID: <4B1E0E56.8020003@kernel.org>
Date: Tue, 08 Dec 2009 17:29:10 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Andrew Morton <akpm@linux-foundation.org>, tony.luck@intel.com,
       linux-mm@kvack.org, Geert Uytterhoeven <geert@linux-m68k.org>,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmalloc: don't use vmalloc_end
References: <4B1D3A3302000078000241CD@vpn.id2.novell.com> <20091207153552.0fadf335.akpm@linux-foundation.org> <4B1E1B1B0200007800024345@vpn.id2.novell.com>
In-Reply-To: <4B1E1B1B0200007800024345@vpn.id2.novell.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/08/2009 05:23 PM, Jan Beulich wrote:
> According to Tejun the problem is just cosmetic (i.e. causes build
> warnings), since the functions affected aren't being used (yet) on
> ia64. So feel free to drop the patch again, given that he has a patch
> queued to address the issue by renaming the arch variable.
> 
> I wonder though why that code is being built on ia64 at all if it's not
> being used (i.e. why it doesn't depend on a CONFIG_*, HAVE_*, or
> NEED_* manifest constant).

Hmm... it shouldn't be building.  Can you please attach .config?

Thanks.

-- 
tejun
