Return-Path: <linux-kernel-owner+w=401wt.eu-S1758834AbYAJTBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834AbYAJTBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754671AbYAJTBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:01:07 -0500
Received: from ns.suse.de ([195.135.220.2]:49534 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754313AbYAJTBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:01:06 -0500
To: venkatesh.pallipadi@intel.com
Cc: ebiederm@xmission.com, rdreier@cisco.com, torvalds@linux-foundation.org,
       gregkh@suse.de, airlied@skynet.ie, davej@redhat.com, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.co, linux-kernel@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch 06/11] PAT x86: Refactoring i386 cpa
From: Andi Kleen <andi@firstfloor.org>
References: <20080110184840.927409000@intel.com>
	<20080110184855.677758000@intel.com>
Date: Thu, 10 Jan 2008 20:00:59 +0100
In-Reply-To: <20080110184855.677758000@intel.com> (venkatesh pallipadi's message of "Thu\, 10 Jan 2008 10\:48\:46 -0800")
Message-ID: <p73bq7to68k.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

venkatesh.pallipadi@intel.com writes:

> This makes 32 bit cpa similar to x86_64 and makes it easier for following PAT
> patches.

Please don't do this -- that would be a nightmare merging with my CPA
series.

This means adding the _addr() entry point is ok (although it should not 
be needed on i386 because it doesn't do the end_pfn_mapped trick), but not 
a wide scale refactoring.

-Andi
