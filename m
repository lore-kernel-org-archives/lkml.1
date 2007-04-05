Return-Path: <linux-kernel-owner+w=401wt.eu-S964852AbXDEI6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964852AbXDEI6r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 04:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965084AbXDEI6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 04:58:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964852AbXDEI6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 04:58:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
X-Fcc: ~/Mail/linus
Cc: Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, Andi Kleen <ak@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, Zachary Amsden <zach@vmware.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 1/2] Relocate VDSO ELF headers to match mapped location with COMPAT_VDSO
In-Reply-To: Jeremy Fitzhardinge's message of  Thursday, 5 April 2007 01:18:35 -0700 <4614B0DB.7040003@goop.org>
X-Windows: you'll envy the dead.
Message-Id: <20070405085840.2AFD8180055@magilla.sf.frob.com>
Date: Thu,  5 Apr 2007 01:58:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Don't change sh_addr in sections with (sh_flags & SHF_ALLOC) == 0.  Also,
I'd concur with Jan's suggestion about paranoia warnings for unexpected
DT_* types (and for unexpected st_shndx >= SHN_LORESERVE).

Otherwise, looks ok to me.


Thanks,
Roland
