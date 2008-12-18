Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908AbYLRViT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbYLRViT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 16:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbYLRViJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 16:38:09 -0500
Received: from ns2.suse.de ([195.135.220.15]:48814 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796AbYLRViI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 16:38:08 -0500
Date: Thu, 18 Dec 2008 22:38:06 +0100
From: Nick Piggin <npiggin@suse.de>
To: venkatesh.pallipadi@intel.com
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, hugh@veritas.com, arjan@infradead.org,
       jbarnes@virtuousgeek.org, rdreier@cisco.com, jeremy@goop.org,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch 4/7] x86 PAT: Implement track/untrack of pfnmap regions for x86 - v3
Message-ID: <20081218213806.GG10681@wotan.suse.de>
References: <20081218194126.963894000@intel.com> <20081218194617.533039000@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081218194617.533039000@intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And that's the end of the mm/ code... yeah the mm/ parts seem OK to me,
with my minor comments addressed I would ack them all.

On Thu, Dec 18, 2008 at 11:41:30AM -0800, venkatesh.pallipadi@intel.com wrote:
> Hookup remap_pfn_range and vm_insert_pfn and corresponding copy and free
> routines with reserve and free tracking.
