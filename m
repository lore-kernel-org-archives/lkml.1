Return-Path: <linux-kernel-owner+w=401wt.eu-S933781AbZLGLTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933781AbZLGLTr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 06:19:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933740AbZLGLTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 06:19:46 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:62078 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933559AbZLGLTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 06:19:45 -0500
X-Trace: 302293468/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.111.197/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.111.197
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhABALBzHEtQKW/F/2dsb2JhbAAI1zeEMwQ
X-IronPort-AV: E=Sophos;i="4.47,354,1257120000"; 
   d="scan'208";a="302293468"
Date: Mon, 7 Dec 2009 11:19:44 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Amerigo Wang <amwang@redhat.com>
cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, stable@kernel.org,
       akpm@linux-foundation.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [Patch] proc: fill 'lib' field in /proc/<pid>/statm
In-Reply-To: <20091207102808.4312.38760.sendpatchset@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0912071101530.29718@sister.anvils>
References: <20091207102808.4312.38760.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Dec 2009, Amerigo Wang wrote:

> Currently, the 'lib' field of /proc/<pid>/statm is
> always 0, we should fill it with the right value,
> the same with 'VmLib'.

The right value (if you're looking for consistency with Linux 2.4)
is the number of currently resident "library" pages: and we don't
know that number - we can't even define what a library is.

We could add some code to make it show the same bogus number as
we show somewhere else, but it has said 0 ever since 2.5.37: so
I don't think it's worth a line of code myself, but bow to others.

> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: stable@kernel.org

What does alarm me is that you think this is fit for -stable!

Hugh
