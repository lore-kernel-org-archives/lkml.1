Return-Path: <linux-kernel-owner+w=401wt.eu-S1752883AbYHMEpC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbYHMEpC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 00:45:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbYHMEox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 00:44:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:58708 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbYHMEox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 00:44:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,199,1217833200"; 
   d="scan'208";a="325764341"
Subject: Re: [PATCH -v3 1/7] kexec jump: clean up #ifdef and comments
From: Huang Ying <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Vivek Goyal <vgoyal@redhat.com>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <20080812204900.db63deaa.akpm@linux-foundation.org>
References: <1218510861.24951.40.camel@caritas-dev.intel.com>
	 <20080812204900.db63deaa.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 13 Aug 2008 12:44:49 +0800
Message-Id: <1218602689.24951.89.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-12 at 20:49 -0700, Andrew Morton wrote:
> On Tue, 12 Aug 2008 11:14:21 +0800 Huang Ying <ying.huang@intel.com> wrote:
> 
> >  	xchg(&kexec_lock, 0);
> 
> kernel/kexec.c: In function 'kernel_kexec':
> kernel/kexec.c:1501: warning: value computed is not used
> 
> Is there any reason why we cannot use the more conventional
> test_and_set_bit() etc, rather than this peculiarity?
> 
> Or perhaps spin_trylock?

Hi, Andrew,

I think it is of no problem to replace xchg() with test_and_set_bit() or
spin_trylock().

Hi, Eric,

Do you have some reason to use xchg() instead of others?

Best Regards,
Huang Ying


