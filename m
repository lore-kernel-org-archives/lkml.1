Return-Path: <linux-kernel-owner+w=401wt.eu-S1756619AbXHVGuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbXHVGuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 02:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbXHVGur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 02:50:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:12820 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774AbXHVGuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 02:50:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,292,1183359600"; 
   d="scan'208";a="120149028"
Subject: Re: [linux-pm] Re: [PATH 1/1] Kexec jump - v2 - kexec jump
From: "Huang, Ying" <ying.huang@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: david@lang.hm, nigel@nigel.suspend2.net,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
In-Reply-To: <20070821101404.GA1704@elf.ucw.cz>
References: <1184483639.1898.99.camel@caritas-dev.intel.com>
	 <20070731095101.GA1774@elf.ucw.cz>
	 <1185954978.1363.23.camel@caritas-dev.intel.com>
	 <20070816102635.GA2039@elf.ucw.cz>
	 <1187331349.28497.9.camel@caritas-dev.intel.com>
	 <20070821101404.GA1704@elf.ucw.cz>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 22 Aug 2007 14:51:11 +0800
Message-Id: <1187765471.20920.62.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 22 Aug 2007 06:50:39.0732 (UTC) FILETIME=[C05C7B40:01C7E488]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-21 at 12:14 +0200, Pavel Machek wrote:
> Ok, I got it to work -- thanks a lot.
> 
> Yes, acpi=off is mandatory. Unfortunately, thinkpad x60 does not boot
> with acpi=off (should we add another test to linux firmware kit?
> Machines should still boot in acpi=off mode...). acpi=off noapic
> nolapic nosmp makes it boot, and that in turn makes kjump work.
> 
> Screen is not refreshed on kjump back to original kernel, but I guess
> that's to be expected. I did not play with framebuffer, yet.
> 
> Maybe it is time to move kjump functionality into -mm and
> kexec-testing?

Now I have worked out a full kexec based hibernation prototype,
including kexec, write out the image, reboot, restore the memory and
jump back. I will release it recently. :)

Best Regards,
Huang Ying
