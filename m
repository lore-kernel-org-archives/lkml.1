Return-Path: <linux-kernel-owner+w=401wt.eu-S1756596AbYEPBtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbYEPBtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 21:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbYEPBtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 21:49:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:57130 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbYEPBtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 21:49:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,494,1204531200"; 
   d="scan'208";a="384251182"
Subject: Re: [PATCH -mm] kexec jump -v9
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Vivek Goyal <vgoyal@redhat.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <m1skwjghen.fsf@frodo.ebiederm.org>
References: <1204773188.4707.109.camel@caritas-dev.intel.com>
	 <20080514205204.GJ30469@redhat.com>
	 <1210830110.23707.141.camel@caritas-dev.intel.com>
	 <20080516005121.GA6926@redhat.com>  <m1skwjghen.fsf@frodo.ebiederm.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 16 May 2008 09:55:02 +0800
Message-ID: <1210902902.23707.164.camel@caritas-dev.intel.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 16 May 2008 01:48:32.0231 (UTC) FILETIME=[F23C5770:01C8B6F6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-15 at 18:35 -0700, Eric W. Biederman wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > ioapic_suspend() is not putting APICs in Legacy mode and that's why
> > we are seeing the issue. It only saves the IOAPIC routing table entries
> > and these entries are restored during ioapic_resume().
> >
> > But I think somebody has to put APICs in legacy mode for normal 
> > hibernation also. Not sure who does it. May be BIOS, so that during
> > resume, second kernel can get the timer interrupts.
> 
> I doubt anything cares in the suspend to ram case. There should just
> be a small BIOS trampoline to get back to linux when the processor
> restarts.  And you don't need interrupts for any of that. 

As far as I know, in suspend to ram, interrupt is used as waking up
event, such as, keyboard interrupt.

Best Regards,
Huang Ying
