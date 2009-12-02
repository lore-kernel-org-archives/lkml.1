Return-Path: <linux-kernel-owner+w=401wt.eu-S1753663AbZLBNJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbZLBNJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 08:09:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbZLBNI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 08:08:59 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59635 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbZLBNI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 08:08:59 -0500
Date: Wed, 2 Dec 2009 14:09:04 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/24] migrate: page could be locked by hwpoison, dont BUG()
Message-ID: <20091202130904.GD18989@one.firstfloor.org>
References: <20091202031231.735876003@intel.com> <20091202043043.840044332@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091202043043.840044332@intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 11:12:33AM +0800, Wu Fengguang wrote:
> The new page could be taken by hwpoison, in which case
> return EAGAIN to allocate a new page and retry.

Previously there were some complaints about this patch, but I guess
it doesn't hurt, so I'll add it.

-Andi
