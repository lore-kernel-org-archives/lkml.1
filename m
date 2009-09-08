Return-Path: <linux-kernel-owner+w=401wt.eu-S1752155AbZIHSG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbZIHSG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 14:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbZIHSG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 14:06:28 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:53273 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751994AbZIHSG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 14:06:28 -0400
X-Trace: 256262944/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.1.197/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.1.197
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArMEAOg5pkpQKQHF/2dsb2JhbACBU91QhBgF
X-IronPort-AV: E=Sophos;i="4.44,353,1249254000"; 
   d="scan'208";a="256262944"
Date: Tue, 8 Sep 2009 19:05:42 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linux Filesystem Mailing List <linux-fsdevel@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>, Mimi Zohar <zohar@us.ibm.com>,
       James Morris <jmorris@namei.org>
Subject: Re: [PATCH 6/8] shmfs: use 'check_acl' instead of 'permission'
In-Reply-To: <alpine.LFD.2.01.0909071404090.3419@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0909081904320.2878@sister.anvils>
References: <alpine.LFD.2.01.0909071337510.3419@localhost.localdomain>
 <alpine.LFD.2.01.0909071401210.3419@localhost.localdomain>
 <alpine.LFD.2.01.0909071402220.3419@localhost.localdomain>
 <alpine.LFD.2.01.0909071402510.3419@localhost.localdomain>
 <alpine.LFD.2.01.0909071403110.3419@localhost.localdomain>
 <alpine.LFD.2.01.0909071403390.3419@localhost.localdomain>
 <alpine.LFD.2.01.0909071404090.3419@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Sep 2009, Linus Torvalds wrote:
> 
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Fri, 28 Aug 2009 12:04:28 -0700
> 
> shmfs wants purely standard POSIX ACL semantics, so we can use the new
> generic VFS layer POSIX ACL checking rather than cooking our own
> 'permission()' function.
> 
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

> ---
>  include/linux/shmem_fs.h |    2 +-
>  mm/shmem.c               |    6 +++---
>  mm/shmem_acl.c           |   11 +----------
>  3 files changed, 5 insertions(+), 14 deletions(-)
