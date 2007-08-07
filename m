Return-Path: <linux-kernel-owner+w=401wt.eu-S1759220AbXHGJ35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759220AbXHGJ35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 05:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755754AbXHGJ3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 05:29:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:17287 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbXHGJ3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 05:29:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,228,1183359600"; 
   d="scan'208";a="114530184"
Subject: Re: [PATCH 5/5] x86_64 EFI support -v3: EFI document
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: ak@suse.de, akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <m1r6mnnpj8.fsf@ebiederm.dsl.xmission.com>
References: <1185851583.23149.30.camel@caritas-dev.intel.com>
	 <m1r6mptcc8.fsf@ebiederm.dsl.xmission.com>
	 <1185865087.23149.50.camel@caritas-dev.intel.com>
	 <m1r6mnnpj8.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 07 Aug 2007 17:29:44 +0800
Message-Id: <1186478984.3769.46.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 07 Aug 2007 09:29:36.0194 (UTC) FILETIME=[7856DA20:01C7D8D5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-02 at 01:16 +0800, Eric W. Biederman wrote:
> > The parameters are rearranged, because the pointer is too small. For
> > example, the EFI system table pointer is 8 bytes in x86_64, while it
> is
> > 4 bytes in i386.
> 
> Ok.  I see what is happening.  When the documentation is for arch/i386
> unsigned long is 4 bytes, and you are using unsigned long to mean 8
> bytes.  For an 8 byte fields please just spell out the size as 8
> bytes.

Ok. Will do in the next version.
> 
> How does EFI handle 32bit/64bit compatibility?  In particular
> how do I load a 32bit kernel on machine with a 64bit EFI?  Can
> it be done?
> 
Because the EFI memory map is converted to E820 map in bootloader now,
it is possible to load 32bit kernel on machine with a 64bit EFI. But it
is almost impossible to call EFI runtime service in 32bit kernel. But I
think EFI runtime service is not essential in this situation, because
the raw hardware can be used too.

Best Regards,
Huang Ying
