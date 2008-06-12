Return-Path: <linux-kernel-owner+w=401wt.eu-S1756944AbYFLBKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944AbYFLBKZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 21:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755339AbYFLBKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 21:10:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:56126 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754928AbYFLBKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 21:10:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,627,1204531200"; 
   d="scan'208";a="393904123"
Subject: Re: [Fedora-ia64-list] Kernel directory change
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: ia64 Fedora Core Development <fedora-ia64-list@redhat.com>,
       dchapman@redhat.com
Cc: Development discussions related to Fedora 
	<fedora-devel-list@redhat.com>,
       yi.zhan@intel.com, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1213189422.3673.2.camel@centrino>
References: <1213145883.3054.8.camel@ymzhang>
	 <1213189422.3673.2.camel@centrino>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 12 Jun 2008 09:04:06 +0800
Message-Id: <1213232646.3054.16.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-06-11 at 09:03 -0400, Doug Chapman wrote:
> On Wed, 2008-06-11 at 08:58 +0800, Zhang, Yanmin wrote:
> > Yi,
> > 
> > I installed FC9 Beta ia64 on my Montvale machine and found the kernel
> > directory is changed. The old directory is /boot/efi/efi/redhat, but the
> > new one is /boot/efi/EFI/redhat. Is there any special reason to do so?
> > 
> > A couple of test suites assumes ﻿/boot/efi/efi/redhat.
> > 
> > -yanmin
> > 
> 
> This changed a while back.  What it appears happened was that the vfat
> filesystem for some reason now understands upper/lower case.  In
> actuality it was always /boot/efi/EFI but the linux implementation of
> vfat shifted the directory name to lower case.
> 
> Note that under the EFI shell it was always an upper case EFI as that is
> what is actually on the filesystem.  I would suggest modifying your test
> to handle either case.
That's not a good idea. Although it's caused by vfat improvements, I would
suggest to keep the old interface.

Long long ago, there was a long discussion about interface change on LKML. It's
a bad idea to change interfaces or API when they become de facto.


