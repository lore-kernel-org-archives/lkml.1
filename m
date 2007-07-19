Return-Path: <linux-kernel-owner+w=401wt.eu-S1763433AbXGSGoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763433AbXGSGoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 02:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755355AbXGSGoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 02:44:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:33252 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929AbXGSGoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 02:44:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,554,1175497200"; 
   d="scan'208";a="107715342"
Subject: Re: [PATH 0/1] Kexec jump - v2 - the first step to kexec based
	hibernation
From: "Huang, Ying" <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Alan Stern <stern@rowland.harvard.edu>, david@lang.hm,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <20070718180420.02352d4f.akpm@linux-foundation.org>
References: <1184483593.1898.98.camel@caritas-dev.intel.com>
	 <20070718180420.02352d4f.akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 19 Jul 2007 14:43:23 +0800
Message-Id: <1184827403.15756.14.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 19 Jul 2007 06:44:06.0839 (UTC) FILETIME=[34224470:01C7C9D0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-18 at 18:04 -0700, Andrew Morton wrote:
> I like the idea but I think I'll let people chat about it a bit more
> before looking at merging the patches, OK?

I think maybe we should wait for Rafael to separate the device hibernate
(quiesce and state save) from device suspend. Without that, the ACPI
issue can not be resolved.

Best Regards,
Huang Ying
