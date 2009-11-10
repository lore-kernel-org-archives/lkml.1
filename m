Return-Path: <linux-kernel-owner+w=401wt.eu-S1758566AbZKJW33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566AbZKJW33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758432AbZKJW31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:29:27 -0500
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:29002 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758488AbZKJW3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:29:24 -0500
X-Trace: 284028145/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.44.180/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.44.180
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjkFAPt3+UpPRSy0/2dsb2JhbACBTt09hD4E
X-IronPort-AV: E=Sophos;i="4.44,718,1249254000"; 
   d="scan'208";a="284028145"
Date: Tue, 10 Nov 2009 22:29:28 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Peter Zijlstra <peterz@infradead.org>
cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Izik Eidus <ieidus@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 5/6] mm: stop ptlock enlarging struct page
In-Reply-To: <1257891277.4108.498.camel@laptop>
Message-ID: <Pine.LNX.4.64.0911102227080.7826@sister.anvils>
References: <Pine.LNX.4.64.0911102142570.2272@sister.anvils> 
 <Pine.LNX.4.64.0911102200480.2816@sister.anvils> <1257891277.4108.498.camel@laptop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Nov 2009, Peter Zijlstra wrote:
> 
> fwiw, in -rt we carry this, because there spinlock_t is huge even
> without lockdep.

Thanks, I may want to consider that; but I'm not keen on darting
off to another cacheline even for the non-debug spinlock case.

Hugh
