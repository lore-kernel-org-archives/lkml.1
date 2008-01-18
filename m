Return-Path: <linux-kernel-owner+w=401wt.eu-S1765779AbYARUvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765779AbYARUvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 15:51:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759358AbYARUvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 15:51:41 -0500
Received: from relay1.sgi.com ([192.48.171.29]:44208 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759068AbYARUvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 15:51:40 -0500
Message-ID: <4791115A.1030209@sgi.com>
Date: Fri, 18 Jan 2008 12:51:38 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] percpu: Per cpu code simplification fixup
References: <20080118182953.748071000@sgi.com> <20080118203928.GB3079@elte.hu>
In-Reply-To: <20080118203928.GB3079@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * travis@sgi.com <travis@sgi.com> wrote:
> 
>> This patchset simplifies the code that arches need to maintain to 
>> support per cpu functionality. Most of the code is moved into arch 
>> independent code. Only a minimal set of definitions is kept for each 
>> arch.
>>
>> The patch also unifies the x86 arch so that there is only a single 
>> asm-x86/percpu.h
>>
>> Based on: 2.6.24-rc8-mm1
> 
> just to make sure i got it right: due to the multi-arch scope of this 
> patchset, this is for -mm, right?
> 
> 	Ingo


Yes, it is.

Thanks,
Mike
