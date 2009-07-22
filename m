Return-Path: <linux-kernel-owner+w=401wt.eu-S1751815AbZGVEkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815AbZGVEkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 00:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbZGVEkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 00:40:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:38819 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbZGVEkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 00:40:07 -0400
Message-ID: <4A6697D9.1000704@kernel.org>
Date: Wed, 22 Jul 2009 13:38:49 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       benh@kernel.crashing.org, davem@davemloft.net, dhowells@redhat.com,
       npiggin@suse.de, JBeulich@novell.com, rusty@rustcorp.com.au,
       hpa@zytor.com, tglx@linutronix.de, akpm@linux-foundation.org,
       x86@kernel.org, andi@firstfloor.org
Subject: Re: [PATCH 03/20] percpu: rename 4k first chunk allocator to page
References: <1248171979-29166-1-git-send-email-tj@kernel.org> <1248171979-29166-4-git-send-email-tj@kernel.org> <alpine.DEB.1.10.0907211745080.25867@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0907211745080.25867@gentwo.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 22 Jul 2009 04:38:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 21 Jul 2009, Tejun Heo wrote:
> 
>> - * Boring fallback 4k allocator.  This allocator puts more pressure on
>> - * PTE TLBs but other than that behaves nicely on both UMA and NUMA.
>> + * Boring fallback 4k page allocator.  This allocator puts more
> 
> Guess this should not mentione 4k anymroe? page size allocation?

That's x86 specific code and PAGE_SIZE is always 4k there, so....
Also, this comment gets completely deleted by later patches anyway.

>>  				pr_warning("PERCPU: %s allocator failed (%zd), "
>> -					   "falling back to 4k\n",
>> +					   "falling back to page\n",
> 
> "falling back to page size"?

So updated.

Thanks.

-- 
tejun
