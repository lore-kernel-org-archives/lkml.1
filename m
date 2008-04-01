Return-Path: <linux-kernel-owner+w=401wt.eu-S1760055AbYDAWbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760055AbYDAWbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 18:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406AbYDAWbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 18:31:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45092 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752841AbYDAWbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 18:31:34 -0400
Date: Tue, 1 Apr 2008 15:31:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       schwidefsky@de.ibm.com, mingo@elte.hu, davem@davemloft.net,
       tony.luck@intel.com, paulus@samba.org, tglx@linutronix.de,
       lethal@linux-sh.org
Subject: Re: [PATCH 0/3] hugetlbfs: cleanup and new primitives for s390
Message-Id: <20080401153102.09af4aca.akpm@linux-foundation.org>
In-Reply-To: <1207058485.5063.36.camel@localhost.localdomain>
References: <1207058485.5063.36.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Apr 2008 16:01:25 +0200
Gerald Schaefer <gerald.schaefer@de.ibm.com> wrote:

> this patchset cleans up hugetlbfs architecture headers and adds new
> primitives as preparation for the s390 large page support. Most notably
> we found that we need to add a new tlb flush for the copy-on-write of
> a large page (patch #2). We think that this is a bug, but obviously one
> that hasn't shown up so far on any of the other large page architectures.
> 
> As there were no objections so far, which would be the right tree for
> this to get it upstream?

-mm, I suppose.

But all the patcehs had the same title and I'd prefer to not have to
invent your patch titles for you.
