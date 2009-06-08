Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbZFHSMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbZFHSMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 14:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbZFHSMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 14:12:08 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:43616 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754067AbZFHSMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 14:12:07 -0400
X-Trace: 211553410/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.38.33/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.38.33
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtEEAE7xLEpQKSYh/2dsb2JhbACBT8w+hAoF
X-IronPort-AV: E=Sophos;i="4.41,325,1241391600"; 
   d="scan'208";a="211553410"
Date: Mon, 8 Jun 2009 19:01:20 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Izik Eidus <ieidus@redhat.com>
cc: aarcange@redhat.com, akpm@linux-foundation.org, nickpiggin@yahoo.com.au,
       chrisw@redhat.com, riel@redhat.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH mmotm] ksm: stop scan skipping pages
In-Reply-To: <4A2D4D9F.8080103@redhat.com>
Message-ID: <Pine.LNX.4.64.0906081852540.8764@sister.anvils>
References: <1242261048-4487-1-git-send-email-ieidus@redhat.com>
 <Pine.LNX.4.64.0906081555360.22943@sister.anvils> <Pine.LNX.4.64.0906081733390.7729@sister.anvils>
 <4A2D4D9F.8080103@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jun 2009, Izik Eidus wrote:
> 
> Thanks for the fix,
> (I saw it while i wrote the RFC patch for the madvise, but beacuse that i
> thought that the RFC fix this (you can see the removel of the second call to
> scan_get_next_index()), and we move to madvise, I thought that no patch is
> needed for this code, guess I was wrong)

Ah, no, I hadn't noticed that, this patch is from several weeks ago,
before you even posted the madvise() version.

I think myself that we ought to fix the algorithm as it stands now in
mmotm, rather than hiding the fix in amongst later interface changes.

But it's not a big deal, so long as it gets fixed in the end.

By the time Andrew sends KVM to Linus, it shouldn't be the
patches currently in mmotm with more on top: they should be
re-presented with all trace of /dev/ksm gone by then.

Hugh
