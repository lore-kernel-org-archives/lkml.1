Return-Path: <linux-kernel-owner+w=401wt.eu-S965250AbZLHAjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965250AbZLHAjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 19:39:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965220AbZLHAjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 19:39:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:57232 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965199AbZLHAjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 19:39:13 -0500
Message-ID: <4B1DA06A.1050004@kernel.org>
Date: Tue, 08 Dec 2009 09:40:10 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Beulich <JBeulich@novell.com>, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, linux-mm@kvack.org, linux-ia64@vger.kernel.org,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] mm/vmalloc: don't use vmalloc_end
References: <4B1D3A3302000078000241CD@vpn.id2.novell.com> <20091207153552.0fadf335.akpm@linux-foundation.org>
In-Reply-To: <20091207153552.0fadf335.akpm@linux-foundation.org>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/08/2009 08:35 AM, Andrew Morton wrote:
> arch/m68k/include/asm/pgtable_mm.h does the same thing.  Did it break too?

Oh... m64k does the same thing.  I think the correct thing to do here
would be to convert arch code as in ia64.  I think defining
VMALLOC_END to vmalloc_end is a bit error-prone.  If it were defined
simply as vmalloc_end, it's unnoticeable by both the compiler and
developer.

Thanks.

-- 
tejun
