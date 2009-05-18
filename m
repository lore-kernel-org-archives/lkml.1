Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbZERDeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbZERDeT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 23:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbZERDeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 23:34:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:27224 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422AbZERDeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 23:34:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,208,1241420400"; 
   d="scan'208";a="143890173"
Date: Mon, 18 May 2009 11:33:37 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 2/4] vmscan: drop PF_SWAPWRITE from zone_reclaim
Message-ID: <20090518033337.GD5869@localhost>
References: <20090513120155.5879.A69D9226@jp.fujitsu.com> <20090513120627.587F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090513120627.587F.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 12:06:51PM +0900, KOSAKI Motohiro wrote:
> Subject: [PATCH] vmscan: drop PF_SWAPWRITE from zone_reclaim
> 
> PF_SWAPWRITE mean ignore write congestion. (see may_write_to_queue())
> 
> foreground reclaim shouldn't ignore it because to write congested device cause
> large IO lantency.
> it isn't better than remote node allocation.

Acked-by: Wu Fengguang <fengguang.wu@intel.com> 
