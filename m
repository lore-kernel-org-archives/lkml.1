Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbYEOFgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbYEOFgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 01:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbYEOFfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 01:35:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:14353 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbYEOFfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 01:35:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,489,1204531200"; 
   d="scan'208";a="383907844"
Subject: Re: [PATCH -mm] kexec jump -v9
From: "Huang, Ying" <ying.huang@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <20080514205204.GJ30469@redhat.com>
References: <1204773188.4707.109.camel@caritas-dev.intel.com>
	 <20080514205204.GJ30469@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 15 May 2008 13:41:50 +0800
Message-ID: <1210830110.23707.141.camel@caritas-dev.intel.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 15 May 2008 05:35:24.0671 (UTC) FILETIME=[797818F0:01C8B64D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Vivek,

On Wed, 2008-05-14 at 16:52 -0400, Vivek Goyal wrote:
[...]
> Ok, I have done some testing on this patch. Currently I have just
> tested switching back and forth between two kernels and it is working for
> me.
> 
> Just that I had to put LAPIC and IOAPIC in legacy mode for it to work. Few
> comments/questions are inline.

It seems that for LAPIC and IOAPIC, there is
lapic_suspend()/lapic_resume() and ioapic_suspend()/ioapic_resume(),
which will be called before/after kexec jump through
device_power_down()/device_power_up(). So, the mechanism for
LAPIC/IOAPIC is there, we may need to check the corresponding
implementation.

Best Regards,
Huang Ying
