Return-Path: <linux-kernel-owner+w=401wt.eu-S1752867AbYHMFSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbYHMFSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 01:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbYHMFSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 01:18:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:62659 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbYHMFSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 01:18:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,199,1217833200"; 
   d="scan'208";a="325770082"
Subject: Re: [PATCH] kexec jump: fix code size checking
From: Huang Ying <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Simon Horman <horms@verge.net.au>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <m1d4kdk2fw.fsf@frodo.ebiederm.org>
References: <1218589475.24951.59.camel@caritas-dev.intel.com>
	 <20080813024701.GA19201@verge.net.au>
	 <1218596715.24951.69.camel@caritas-dev.intel.com>
	 <m1d4kdk2fw.fsf@frodo.ebiederm.org>
Content-Type: text/plain
Date: Wed, 13 Aug 2008 13:18:12 +0800
Message-Id: <1218604692.24951.92.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-12 at 20:40 -0700, Eric W. Biederman wrote:
[...]
> 4) Put the code is a special section .text.kexec? and have the linker
>    always do the size comparison and the computation of the section size.
> 
> The fewer conditionals we have the less likely something is to break.

Yes. This one is good. But I think current one is acceptable too.

Best Regards,
Huang Ying


