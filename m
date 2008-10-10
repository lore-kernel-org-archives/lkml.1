Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbYJJBGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbYJJBGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 21:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753648AbYJJBGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 21:06:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:35467 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623AbYJJBGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 21:06:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,385,1220252400"; 
   d="scan'208";a="625378866"
Subject: Re: 2.6.27-rc8: throttling broken
From: Zhao Yakui <yakui.zhao@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@suse.cz>
Cc: Pavel Machek <pavel@suse.cz>, jikos@suse.cz,
       kernel list <linux-kernel@vger.kernel.org>, linux-acpi@ucw.cz,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
In-Reply-To: <200810092327.26301.rjw@sisk.pl>
References: <20081009171238.GB1370@ucw.cz>  <200810092327.26301.rjw@sisk.pl>
Content-Type: text/plain
Date: Fri, 10 Oct 2008 09:12:05 +0800
Message-Id: <1223601125.3990.4.camel@yakui_zhao.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-09 at 23:27 +0200, Rafael J. Wysocki wrote:
> On Thursday, 9 of October 2008, Pavel Machek wrote:
> > Hi!
> > 
> > On 2.6.27-rc8 on via/fic subnotebook, throttling seems to be broken. I
> > can do echo 15 > /proc/acpi/processor/*/throttling, and proc file
> > reflects new value, but cpu still runs at same speed.
> > 
> > It worked on opensuse11/sled10 kernels at least...
After echo 15 > /proc/acpi/processor/*/throttling, what T-state is
displayed by cat /proc/acpi/processor/*/throttling?

If you do the above test on the 2.6.26.x kernel, what T-state is
displayed ?
Thanks.
> 
> Any chance to check 2.6.26.x on that?
> 
> Thanks,
> Rafael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

