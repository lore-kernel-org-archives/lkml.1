Return-Path: <linux-kernel-owner+w=401wt.eu-S932856AbXIGPui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932856AbXIGPui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 11:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932448AbXIGPu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 11:50:29 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55535 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932531AbXIGPu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 11:50:29 -0400
Message-ID: <46E171AF.8060502@sgi.com>
Date: Fri, 07 Sep 2007 08:43:43 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] core: fix build error when referencing arch specific
 structures
References: <20070907040943.467530005@sgi.com> <200709070828.05730.ak@suse.de>
In-Reply-To: <200709070828.05730.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Friday 07 September 2007 05:09, travis@sgi.com wrote:
>> Since the core kernel routines need to reference cpu_sibling_map,
>> whether it be a static array or a per_cpu data variable, an access
>> function has been defined.
>>
>> In addition, changes have been made to the ia64 and ppc64 arch's to
>> move the cpu_sibling_map from a static cpumask_t array [NR_CPUS] to
>> be per_cpu cpumask_t arrays.
>>
>> Note that I do not have the ability to build or test patch 3/3, the
>> ppc64 changes.
>>
>> Patches are referenced against 2.6.23-rc4-mm1 .
> 
> It would be better if you could redo the patches with the original patches
> reverted, not incremental changes. In the end we'll need a full patch set
> with full changelog anyways, not a series of incremental fixes.

Will do.  Thanks.

I take it I should run a diff against rc4 (w/o mm1) to regenerate a
complete patch, including the prior ones?

> 
> Also I guess some powerpc testers would be needed. Perhaps cc the
> maintainers?

I've been looking for where to Cc: those guys (as Andrew probably realizes
from his extra "spam" from me. ;-)

Thanks!
Mike
