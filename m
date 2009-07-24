Return-Path: <linux-kernel-owner+w=401wt.eu-S1752376AbZGXKFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376AbZGXKFE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 06:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbZGXKFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 06:05:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42216 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbZGXKFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 06:05:02 -0400
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, venkatesh.pallipadi@intel.com
Subject: Re: [PATCH] x86: Use clflush() instead of wbinvd() whenever possible when changing mapping
From: Andi Kleen <andi@firstfloor.org>
References: <1248421981-31865-1-git-send-email-thellstrom@vmware.com>
Date: Fri, 24 Jul 2009 12:05:01 +0200
In-Reply-To: <1248421981-31865-1-git-send-email-thellstrom@vmware.com> (Thomas Hellstrom's message of "Fri, 24 Jul 2009 09:53:01 +0200")
Message-ID: <87ocra1jn6.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Hellstrom <thellstrom@vmware.com> writes:

> The current code uses wbinvd() when the area to flush is > 4MB. Although this
> may be faster than using clflush() the effect of wbinvd() on irq latencies
> may be catastrophical on systems with large caches. Therefore use clflush()

may be? You seem to miss some hard data here.

I wouldn't expect wbinvd to take longer than a ms or two, which 
is probably not catastrophic yet.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
