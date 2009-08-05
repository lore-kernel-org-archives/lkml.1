Return-Path: <linux-kernel-owner+w=401wt.eu-S934435AbZHEOKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934435AbZHEOKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 10:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934240AbZHEOKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 10:10:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35499 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933568AbZHEOKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 10:10:01 -0400
Date: Wed, 5 Aug 2009 16:10:01 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       fengguang.wu@intel.com, hidehiro.kawai.ez@hitachi.com
Subject: Re: [PATCH] [11/19] HWPOISON: Refactor truncate to allow direct
	truncating of page v2
Message-ID: <20090805141001.GJ11385@basil.fritz.box>
References: <200908051136.682859934@firstfloor.org> <20090805093638.D3754B15D8@basil.firstfloor.org> <20090805102008.GB17190@wotan.suse.de> <20090805134607.GH11385@basil.fritz.box> <20090805140145.GB28563@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090805140145.GB28563@wotan.suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I haven't brought up the caller at this point, but IIRC you had
> the page locked and mapping confirmed at this point anyway so
> it would never be an error for your code.
> 
> Probably it would be nice to just force callers to verify the page.
> Normally IMO it is much nicer and clearer to do it at the time the
> page gets locked, unless there is good reason otherwise.

Ok. I think I'll just keep it as it is for now.

The only reason I added the error code was to make truncate_inode_page
fit into .error_remove_page, but then latter I did another wrapper
so it could be removed again. But it won't hurt to have it either.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
