Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbYAQSwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbYAQSwD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 13:52:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbYAQSvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 13:51:54 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48948 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751925AbYAQSvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 13:51:53 -0500
Message-ID: <478FA3C6.5060401@sgi.com>
Date: Thu, 17 Jan 2008 10:51:50 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <ak@suse.de>, mingo@elte.hu, Eric Dumazet <dada1@cosmosbay.com>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86: Fixup NR-CPUS patch for numa
References: <20080116183438.506737000@sgi.com>	<20080116183438.636758000@sgi.com> <20080117103000.5e97dcd2.akpm@linux-foundation.org>
In-Reply-To: <20080117103000.5e97dcd2.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 16 Jan 2008 10:34:39 -0800 travis@sgi.com wrote:
> 
>> This patch removes the EXPORT_SYMBOL for:
>>
>> 	x86_cpu_to_node_map_init
>> 	x86_cpu_to_node_map_early_ptr
>>
>> ... thus fixing the section mismatch problem.
> 
> Which section mismatch problem?  Please always quote the error message when
> fixing things like this.

Will do.  Basically, it's the error that caused you to add 

	arch-x86-mm-numa_64c-section-fix.patch
> 
>> Also, the mem -> node hash lookup is fixed.
>>
>> Based on 2.6.24-rc6-mm1 + change-NR_CPUS-V3 patchset
>>
> 
> hm, I've been hiding from those patches.
> 
> Are they ready?

Please wait a moment.  I'm resolving the conflicts between what's
in 2.6.24-rc8-mm1 and what's not.  I'll resubmit everything shortly.

Thanks!
Mike
