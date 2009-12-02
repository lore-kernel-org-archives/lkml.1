Return-Path: <linux-kernel-owner+w=401wt.eu-S1753937AbZLBNNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbZLBNNY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 08:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbZLBNNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 08:13:24 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39972 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618AbZLBNNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 08:13:23 -0500
Date: Wed, 2 Dec 2009 14:13:30 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/24] HWPOISON: remove the free buddy page handler
Message-ID: <20091202131330.GF18989@one.firstfloor.org>
References: <20091202031231.735876003@intel.com> <20091202043044.878843398@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091202043044.878843398@intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 11:12:41AM +0800, Wu Fengguang wrote:
> The buddy page has already be handled in the very beginning.
> So remove redundant code.

I think I prefer the table to be complete, even if some of the 
cases might not happen currently. A BUG() would be reasonable though.

-Andi
