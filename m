Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbXCSMFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbXCSMFB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 08:05:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753812AbXCSMFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 08:05:01 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:14633 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807AbXCSMFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 08:05:00 -0400
Date: Mon, 19 Mar 2007 05:04:21 -0700
From: Bill Irwin <bill.irwin@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Blaisorblade <blaisorblade@yahoo.it>, Bill Irwin <bill.irwin@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch 4/6] mm: merge populate and nopage into fault (fixes nonlinear)
Message-ID: <20070319120421.GZ18774@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Nick Piggin <npiggin@suse.de>, Blaisorblade <blaisorblade@yahoo.it>,
	Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management <linux-mm@kvack.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <20070221023735.6306.83373.sendpatchset@linux.site> <200703130001.13467.blaisorblade@yahoo.it> <20070313011904.GA2746@wotan.suse.de> <200703171317.01074.blaisorblade@yahoo.it> <20070318025010.GA1671@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070318025010.GA1671@wotan.suse.de>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2007 at 03:50:10AM +0100, Nick Piggin wrote:
> Yes, that should be the case. So would this mean that nonlinear protections
> don't work on regular files? I guess that's OK if Oracle and UML both use
> tmpfs/shm?

Sometimes ramfs is also used in the Oracle case. I presume that's even
simpler than tmpfs. (Hugetlb, while also used in for the same general
buffer pool, is never used in conjunction with remap_file_pages() etc.)


-- wli
