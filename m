Return-Path: <linux-kernel-owner+w=401wt.eu-S933101AbXLNT6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933101AbXLNT6J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 14:58:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762058AbXLNT5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 14:57:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44221 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760928AbXLNT5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 14:57:48 -0500
Message-ID: <4762DD62.6060803@zytor.com>
Date: Fri, 14 Dec 2007 11:45:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <ak@muc.de>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, venkatesh.pallipadi@intel.com,
       rdreier@cisco.com, torvalds@linux-foundation.org, gregkh@suse.de,
       airlied@skynet.ie, davej@redhat.com, mingo@elte.hu, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [RFC PATCH 02/12] PAT 64b: Basic PAT implementation
References: <20071213235543.568682000@intel.com> <20071213235711.464325000@intel.com> <m1d4taq6le.fsf@ebiederm.dsl.xmission.com> <20071214102535.GB9705@muc.de>
In-Reply-To: <20071214102535.GB9705@muc.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> I do know we need to use the low 4 pat mappings to avoid most of the PAT
>> errata issues.
> 
> They don't really matter. These are all very old systems who have run 
> fine for many years without PAT. It is no problem to let them
> continue to do so and just disable PAT for them. So just clear pat bit in
> CPU initialization for any CPUs with non trivial erratas in this
> area.
> 
> PAT is only really needed on modern boxes.

How many mapping types do we actually need?  The only ones which are 
likely to be used in practice are WB, UC, WC, which still leaves a 
spare.  (Any intended users of WP or WT?)

	-hpa
