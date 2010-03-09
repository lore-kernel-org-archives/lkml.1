Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab0CIJGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 04:06:40 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:40856 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753539Ab0CIJGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 04:06:37 -0500
Date: Tue, 9 Mar 2010 10:06:35 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Wang, Shane" <shane.wang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "Brown, Len" <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       "Cihula, Joseph" <joseph.cihula@intel.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>
Subject: Re: [PATCH v2] intel_txt: add support for S3 memory integrity
	protection within Intel(R) TXT launched kernel
Message-ID: <20100309090635.GA30549@atrey.karlin.mff.cuni.cz>
References: <4A9CE0B2.5060608@intel.com> <4ABF2B50.6070106@intel.com> <20091004185801.GC1378@ucw.cz> <D5AB6E638E5A3E4B8F4406B113A5A19A1D44A8FA@shsmsx501.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D5AB6E638E5A3E4B8F4406B113A5A19A1D44A8FA@shsmsx501.ccr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> v2: Based on a complexity analysis and tradeoff, we moved all MAC'ing into tboot.
> 
> This patch adds support for S3 memory integrity protection within an Intel(R) TXT launched kernel, for all kernel and userspace memory.  All RAM used by the kernel and userspace, as indicated by memory ranges of type E820_RAM and E820_RESERVED_KERN in the e820 table, will be integrity protected.
> 

Please wrap at 80 columns.

> The MAINTAINERS file is also updated to reflect the maintainers of
>  the TXT-related code.

> Signed-off-by: Shane Wang <shane.wang@intel.com>
> Signed-off-by: Joseph Cihula <joseph.cihula@intel.com>

Certainly looks better now. ACK.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
