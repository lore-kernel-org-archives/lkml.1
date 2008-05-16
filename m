Return-Path: <linux-kernel-owner+w=401wt.eu-S1755747AbYEPBmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747AbYEPBmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 21:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbYEPBmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 21:42:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:54448 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765AbYEPBmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 21:42:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,494,1204531200"; 
   d="scan'208";a="328876244"
Subject: Re: [PATCH -mm] kexec jump -v9
From: "Huang, Ying" <ying.huang@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <20080515200923.GC9718@redhat.com>
References: <1204773188.4707.109.camel@caritas-dev.intel.com>
	 <20080514205204.GJ30469@redhat.com>
	 <1210818762.23707.102.camel@caritas-dev.intel.com>
	 <20080515200923.GC9718@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 16 May 2008 09:48:34 +0800
Message-ID: <1210902514.23707.161.camel@caritas-dev.intel.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 16 May 2008 01:42:04.0486 (UTC) FILETIME=[0B1F2660:01C8B6F6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-15 at 16:09 -0400, Vivek Goyal wrote:
[...]
> Ok, You want to make BIOS calls. We already do that using vm86 mode and
> use bios real mode interrupts. So why do we need this interface? Or, IOW,
> how is this interface better?

It can call code in 32-bit physical mode in addition to real mode. So It
can be used to call EFI runtime service, especially call EFI 64 runtime
service under 32-bit kernel or vice versa.

The main purpose of kexec jump is for hibernation. But I think if the
effort is small, why not support general 32-bit physical mode code call
at same time.

Best Regards,
Huang Ying

