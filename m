Return-Path: <linux-kernel-owner+w=401wt.eu-S1752416AbZL1R3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416AbZL1R3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 12:29:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbZL1R3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 12:29:08 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42754 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbZL1R3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 12:29:05 -0500
Date: Mon, 28 Dec 2009 18:29:03 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] [mmotm] Add notifiers for various swap events
Message-ID: <20091228172903.GF4994@basil.fritz.box>
References: <1261963200-7136-1-git-send-email-ngupta@vflare.org> <87eimf87m5.fsf@basil.nowhere.org> <4B38D0CF.9000403@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B38D0CF.9000403@vflare.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The first question to ask is if compressed swap is worth
> > it. Do you have benchmark numbers showing it to be an improvement?
> > Are there cases where it is slower than uncompressed swap?
> > 
> 
> http://code.google.com/p/compcache/wiki/Performance

That should be included in the changelog of the patches.

> ramzswap is an optional module.

I have some doubts on the wisdom of making swap algorithms modular.
Better compile them in. Then you don't need messy notifiers either.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
