Return-Path: <linux-kernel-owner+w=401wt.eu-S1754475AbZHCVNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbZHCVNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 17:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbZHCVNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 17:13:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56853 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbZHCVNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 17:13:46 -0400
To: Sage Weil <sage@newdream.net>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       Neil Brown <neilb@suse.de>, <stable@kernel.org>
Subject: Re: [PATCH] md: avoid use of broken kzalloc mempool
From: Andi Kleen <andi@firstfloor.org>
References: <1249332888-13440-1-git-send-email-sage@newdream.net>
Date: Mon, 03 Aug 2009 23:13:46 +0200
In-Reply-To: <1249332888-13440-1-git-send-email-sage@newdream.net> (Sage Weil's message of "Mon,  3 Aug 2009 13:54:46 -0700")
Message-ID: <87prbcr46t.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sage Weil <sage@newdream.net> writes:

> The kzalloc mempool does not re-zero items that have been used and then
> returned to the pool.  Manually zero the allocated multipath_bh instead.

Why not fix that in mempool instead? That would seem like the right place
to fix such a bug, instead of adding workarounds to all callers.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
