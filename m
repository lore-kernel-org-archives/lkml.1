Return-Path: <linux-kernel-owner+w=401wt.eu-S1755198AbYHKSxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbYHKSxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 14:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbYHKSxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 14:53:21 -0400
Received: from mga14.intel.com ([143.182.124.37]:17388 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093AbYHKSxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 14:53:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,189,1217833200"; 
   d="scan'208";a="32447168"
Message-ID: <48A08A11.8040507@intel.com>
Date: Mon, 11 Aug 2008 11:50:57 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080626)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: netdev@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: tbench regression on each kernel release from  2.6.22 -> 2.6.28
References: <48A086B6.2000901@linux-foundation.org>
In-Reply-To: <48A086B6.2000901@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Aug 2008 18:53:18.0734 (UTC) FILETIME=[84FC62E0:01C8FBE3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> It seems that the network stack becomes slower over time? Here is a list of
> tbench results with various kernel versions:
> 
> 2.6.22		3207.77 mb/sec
> 2.6.24		3185.66
> 2.6.25		2848.83
> 2.6.26		2706.09
> 2.6.27(rc2)	2571.03
> 
> And linux-next is:
> 
> 2.6.28(l-next)	2568.74
> 
> It shows that there is still have work to be done on linux-next. Too close to
> upstream in performance.
> 
> Note the KT event between 2.6.24 and 2.6.25. Why is that?

is this with SLAB or with SLUB? SLUB has been known to impact network performance...

Auke


