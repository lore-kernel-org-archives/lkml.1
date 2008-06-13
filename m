Return-Path: <linux-kernel-owner+w=401wt.eu-S1758491AbYFMBQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758491AbYFMBQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 21:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757941AbYFMBQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 21:16:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:42826 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035AbYFMBQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 21:16:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,634,1204531200"; 
   d="scan'208";a="339775893"
Subject: Re: [PATCH -mm 2/2] kexec jump -v11: save/restore device state
From: "Huang, Ying" <ying.huang@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <20080612130225.GA9654@redhat.com>
References: <1213082106.22608.30.camel@caritas-dev.intel.com>
	 <20080611163026.GG6450@redhat.com>
	 <1213232019.21353.8.camel@caritas-dev.intel.com>
	 <20080612130225.GA9654@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 13 Jun 2008 09:18:52 +0800
Message-Id: <1213319932.22697.9.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 13 Jun 2008 01:16:12.0193 (UTC) FILETIME=[11730910:01C8CCF3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-12 at 09:02 -0400, Vivek Goyal wrote:
[...]
> Few things I don't understand.
> 
> - Are you saying that hibernated image will be saved in initrd
>   (rootfs.gz)? But that saving is only in RAM, we never write back
>   it to disk?

No. Hibernated image should be saved in a dedicated raw partition as you
said below.

> - I thought we probably have to dedicate a raw partition kind of thing
>   for saving image and then modify boot loader command line to something
>   similar to, "resume=partition". Then initrd can go hunting for image
>   in respective partition (as specified by command line parameter) and if
>   image is not available then continue with normal boot.

Yes. But the boot-loader command line only need to be changed during
system install or hibernation setup. We need not change the location of
"hibernation partition" frequently.

So I think one boot-loader command line is sufficient for:

- normal boot
- normal boot a system to be hibernated
- boot helper system to restore the hibernated system

Best Regards,
Huang Ying

