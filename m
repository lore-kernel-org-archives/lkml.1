Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbZLCBpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbZLCBpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 20:45:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbZLCBpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 20:45:14 -0500
Received: from mga14.intel.com ([143.182.124.37]:29955 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754051AbZLCBpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 20:45:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="218197794"
Date: Thu, 3 Dec 2009 09:45:18 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/24] HWPOISON: make it possible to unpoison pages
Message-ID: <20091203014518.GB8520@localhost>
References: <20091202031231.735876003@intel.com> <20091202043045.150526892@intel.com> <20091202131530.GG18989@one.firstfloor.org> <20091202134645.GA19274@localhost> <20091202140305.GL18989@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091202140305.GL18989@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 10:03:05PM +0800, Andi Kleen wrote:
> > btw, do you feel comfortable with the interface name "renew-pfn"?
> > (versus "unpoison-pfn")
> 
> I prefer unpoison, that makes it clear what it is.

OK.

> Maybe even call it "software_unpoison_pfn", because it won't unpoison on the 
> hardware level (this really should be documented somewhere too)

Yes we can document it in Documentation/vm/hwpoison.txt.

Does that mean we may introduce a "hardware_unpoison_pfn" in future?
(a superset of software_unpoison_pfn)

And "software_unpoison_pfn" may make the other "corrupt-pfn" a bit
confusing ;)


Thanks,
Fengguang
