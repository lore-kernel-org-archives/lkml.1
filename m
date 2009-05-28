Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbZE1H4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbZE1H4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 03:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbZE1H4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 03:56:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48874 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbZE1H4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 03:56:38 -0400
Date: Thu, 28 May 2009 10:03:19 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, Lee.Schermerhorn@hp.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com
Subject: Re: [PATCH] [9/16] HWPOISON: Use bitmask/action code for try_to_unmap behaviour
Message-ID: <20090528080319.GA1065@one.firstfloor.org>
References: <200905271012.668777061@firstfloor.org> <20090527201235.9475E1D0292@basil.firstfloor.org> <20090528072703.GF6920@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528072703.GF6920@wotan.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 09:27:03AM +0200, Nick Piggin wrote:
> Not a bad idea, but I would prefer to have a set of flags which tell
> try_to_unmap what to do, and then combine them with #defines for
> callers. Like gfp flags.

That's exactly what the patch does?

It just has actions and flags because the actions can be contradictory.

> And just use regular bitops rather than this TTU_ACTION macro.

TTU_ACTION does mask against multiple bits. None of the regular
bitops do that. 

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
