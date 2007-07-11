Return-Path: <linux-kernel-owner+w=401wt.eu-S1763751AbXGKSPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763751AbXGKSPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 14:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756876AbXGKSPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 14:15:24 -0400
Received: from gw.goop.org ([64.81.55.164]:35744 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756312AbXGKSPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 14:15:23 -0400
Message-ID: <46951DFD.5080805@goop.org>
Date: Wed, 11 Jul 2007 11:14:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, Tim Hockin <thockin@google.com>,
       jesse.barnes@intel.com, Adrian Bunk <bunk@stusta.de>,
       dave young <hidave.darkstar@gmail.com>
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <p734pkbyuu4.fsf@bingen.suse.de>
In-Reply-To: <p734pkbyuu4.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> More review: 
>
>   
>> xen-fix-x86-config-dependencies.patch
>> xen-suppress-abs-symbol-warnings-for-unused-reloc-pointers.patch
>> xen-cant-support-numa-yet.patch
>>     

The first and third of these are just simple Kconfig updates, and the 
middle one just updates the list of symbols which shouldn't be warned 
about in CONFIG_RELOCATABLE's absolute symbol check.  They're completely 
harmless but may prevent someone from generating an unbuildable .config.

>> x86-fix-iounmaps-use-of-vm_structs-size-field.patch
>>     

This appears to fix a real bug; the only question is whether x86-64 
needs the same treatment.  I'm not sure if the original bug reporter 
(dave young) has confirmed it fixed his problem.

    J
