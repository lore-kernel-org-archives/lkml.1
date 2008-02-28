Return-Path: <linux-kernel-owner+w=401wt.eu-S1764698AbYB1VLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764698AbYB1VLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 16:11:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759851AbYB1VLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 16:11:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754291AbYB1VLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 16:11:22 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       shaohua.li@intel.com, linux-ia64@vger.kernel.org
Subject: Re: [PATCH] core dump: user_regset writeback
In-Reply-To: Andrew Morton's message of  Thursday, 28 February 2008 12:45:22 -0800 <20080228124522.3ae08f19.akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <20080227200638.15D092700FD@magilla.localdomain>
	<20080228124522.3ae08f19.akpm@linux-foundation.org>
X-Windows: form follows malfunction.
Message-Id: <20080228211047.AFDF92700FD@magilla.localdomain>
Date: Thu, 28 Feb 2008 13:10:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is there a need for this in 2.6.25?

It is a prerequisite for ia64 to switch on CORE_DUMP_USE_REGSET.  (It's
also a very low-impact patch easy to convince oneself does nothing on other
machines, and it's in new 2.6.25 code so far used only on x86, powerpc, and
sparc.)  I think those patches are on their way to being merged by ia64
maintainers.  But I don't know what their targets are.  I'm guessing not
til after .25.  Shaohua Li is driving that effort.


Thanks,
Roland
