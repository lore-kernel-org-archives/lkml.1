Return-Path: <linux-kernel-owner+w=401wt.eu-S1755778AbZHFNLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbZHFNLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 09:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755754AbZHFNLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 09:11:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42962 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755715AbZHFNLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 09:11:44 -0400
Message-ID: <4A7AD681.3090709@redhat.com>
Date: Thu, 06 Aug 2009 09:11:29 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
References: <20090805024058.GA8886@localhost> <20090805155805.GC23385@random.random> <20090806100824.GO23385@random.random> <4A7AAE07.1010202@redhat.com> <20090806102057.GQ23385@random.random> <20090806105932.GA1569@localhost>
In-Reply-To: <20090806105932.GA1569@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:

> This is a quick hack to materialize the idea. It remembers roughly
> the last 32*SWAP_CLUSTER_MAX=1024 active (mapped) pages scanned,
> and if _all of them_ are referenced, then the referenced bit is
> probably meaningless and should not be taken seriously.

This has the potential to increase the number of active
pages scanned by almost a factor 1024.  Let me whip up an
alternative idea when I get to the office later today.

-- 
All rights reversed.
