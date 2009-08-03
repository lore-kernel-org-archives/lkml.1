Return-Path: <linux-kernel-owner+w=401wt.eu-S1754774AbZHCV31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbZHCV31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 17:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbZHCV30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 17:29:26 -0400
Received: from cobra.newdream.net ([66.33.216.30]:59357 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717AbZHCV3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 17:29:25 -0400
Date: Mon, 3 Aug 2009 14:29:26 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       Neil Brown <neilb@suse.de>, stable@kernel.org
Subject: Re: [PATCH] md: avoid use of broken kzalloc mempool
In-Reply-To: <87prbcr46t.fsf@basil.nowhere.org>
Message-ID: <Pine.LNX.4.64.0908031423140.7580@cobra.newdream.net>
References: <1249332888-13440-1-git-send-email-sage@newdream.net>
 <87prbcr46t.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Aug 2009, Andi Kleen wrote:
> Sage Weil <sage@newdream.net> writes:
> 
> > The kzalloc mempool does not re-zero items that have been used and then
> > returned to the pool.  Manually zero the allocated multipath_bh instead.
> 
> Why not fix that in mempool instead? That would seem like the right place
> to fix such a bug, instead of adding workarounds to all callers.

That was my original proposal, but Andrew suggested it wasn't worth the 
added complexity for only 2 users (or actually, just 1).  See this thread:

http://marc.info/?l=linux-mm&m=124933189913260&w=2

sage
