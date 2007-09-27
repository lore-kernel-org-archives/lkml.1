Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbXI0GcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbXI0GcE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 02:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbXI0Gby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 02:31:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:52044 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbXI0Gbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 02:31:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,201,1188802800"; 
   d="scan'208";a="326402900"
Subject: Re: [RFC][PATCH 1/2 -mm] kexec based hibernation -v3: kexec jump
From: "Huang, Ying" <ying.huang@intel.com>
To: Joseph Fannin <jfannin@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, "Eric W. Biederman" <ebiederm@xmission.com>,
       nigel@suspend2.net, Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <20070926203036.GF31759@nineveh.local>
References: <1190266447.21818.17.camel@caritas-dev.intel.com>
	 <200709211225.25874.nigel@nigel.suspend2.net>
	 <1190342757.21818.75.camel@caritas-dev.intel.com>
	 <200709211259.00195.nigel@nigel.suspend2.net>
	 <m1r6ksiq27.fsf@ebiederm.dsl.xmission.com>
	 <20070921094512.GA20149@elf.ucw.cz>  <20070926203036.GF31759@nineveh.local>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 27 Sep 2007 14:33:54 +0800
Message-Id: <1190874834.21818.300.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 27 Sep 2007 06:31:44.0857 (UTC) FILETIME=[12CB4C90:01C800D0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-26 at 16:30 -0400, Joseph Fannin wrote:
>     But, in my ignorance, I'm not sure even fixing the ext3 bug will
> guarantee you consistent metadata so that you can handle a
> swap/hibernate file.  You can do a sync(), but how do you make that
> not race against running processes without the freezer, or blkdev
> snapshots?
> 
>     I guess uswsusp and the-patch-previously-known-as-suspend2 handle
> this somehow, though.

The image-writing kernel of kexec based hibernation run in a controlled
way. It is not used by normal user, so only really necessary process
need to be run. For example, it is possible that there is only one user
process -- the image-writing process running in image-writing kernel.
So, no freezer or blkdev snapshot is needed.

Best Regards,
Huang Ying
