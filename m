Return-Path: <linux-kernel-owner+w=401wt.eu-S1755971AbYFPB0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbYFPB0v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 21:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbYFPB0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 21:26:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:25717 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbYFPB0d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 21:26:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,649,1204531200"; 
   d="scan'208";a="341486355"
Subject: Re: [linux-pm] [PATCH -mm 2/2] kexec jump -v11: save/restore
	device state
From: "Huang, Ying" <ying.huang@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Len Brown <lenb@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080613180555.GB4906@redhat.com>
References: <1213082106.22608.30.camel@caritas-dev.intel.com>
	 <alpine.LFD.1.10.0806101400090.14381@localhost.localdomain>
	 <1213146074.21923.10.camel@caritas-dev.intel.com>
	 <20080613180555.GB4906@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Mon, 16 Jun 2008 09:29:23 +0800
Message-Id: <1213579763.7179.1.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 16 Jun 2008 01:26:29.0170 (UTC) FILETIME=[006F8120:01C8CF50]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿Hi, Vivek,

On Fri, 2008-06-13 at 14:05 -0400, Vivek Goyal wrote:
[...]
> 
> Can't we implement ACPI S5 state as an option in current hibernation
> framework? Or kexec jump is a requirement for that? 

ACPI S5 has been implemented in current hibernation framework. If you
do:

    echo shutdown > /sys/power/disk

ACPI S5 instead of S4 will be used. That is, corresponding ACPI method
is not executed.

Best Regards,
Huang Ying

