Return-Path: <linux-kernel-owner+w=401wt.eu-S1763151AbZFPVDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763151AbZFPVDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 17:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758063AbZFPVDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 17:03:44 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:33837 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761821AbZFPVDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 17:03:43 -0400
X-Trace: 213089703/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.95.160/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.95.160
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlEGAOqkN0pQKV+g/2dsb2JhbACBT9NuhAsF
X-IronPort-AV: E=Sophos;i="4.42,231,1243810800"; 
   d="scan'208";a="213089703"
Date: Tue, 16 Jun 2009 22:02:48 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andrea Arcangeli <aarcange@redhat.com>
cc: Rik van Riel <riel@redhat.com>, Izik Eidus <ieidus@redhat.com>,
       linux-kernel@vger.kernel.org, nickpiggin@yahoo.com.au
Subject: Re: running get_user_pages() from kernel thread
In-Reply-To: <20090616203844.GE23969@random.random>
Message-ID: <Pine.LNX.4.64.0906162158100.12770@sister.anvils>
References: <4A37DEE7.1000208@redhat.com> <20090616181325.GC23969@random.random>
 <Pine.LNX.4.64.0906161930050.24878@sister.anvils> <4A37EA92.7050509@redhat.com>
 <Pine.LNX.4.64.0906162035240.2933@sister.anvils> <20090616203844.GE23969@random.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009, Andrea Arcangeli wrote:
> On Tue, Jun 16, 2009 at 08:45:05PM +0100, Hugh Dickins wrote:
> > liking the below better - what do you think?  If you approve, I'll send
> > it in to Andrew for mmotm: I can't quite justify it without KSM.
> 
> I think it's definitely better to fix gup to be safe from kernel
> thread even without KSM so this can go in mainline well before KSM.
> Unless gup requires a swapin fault it won't ever trigger.

Yes, you're right, it should go into 2.6.31, no reason not.

Hugh
