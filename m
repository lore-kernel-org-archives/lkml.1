Return-Path: <linux-kernel-owner+w=401wt.eu-S1762669AbXGLJTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762669AbXGLJTE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 05:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755348AbXGLJSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 05:18:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:17153 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbXGLJSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 05:18:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,531,1175497200"; 
   d="scan'208";a="265267924"
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec
	base	hibernation
From: "Huang, Ying" <ying.huang@intel.com>
To: david@lang.hm
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <Pine.LNX.4.64.0707112345250.28090@asgard.lang.hm>
References: <1184167831.12556.13.camel@caritas-dev.intel.com>
	 <20070711172243.ab44c4d4.akpm@linux-foundation.org>
	 <1184251423.9346.55.camel@caritas-dev.intel.com>
	 <Pine.LNX.4.64.0707112345250.28090@asgard.lang.hm>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 12 Jul 2007 17:18:03 +0000
Message-Id: <1184260683.9346.91.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 12 Jul 2007 09:18:48.0864 (UTC) FILETIME=[A7C2A200:01C7C465]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-12 at 00:03 -0700, david@lang.hm wrote:
> >
> > The kexec jump is the first step, maybe the simplest step. There are
> > many other issues to be resolved, at least the following ones.
> >
> > 1. Separate device suspend from device hibernate.
> 

Maybe my usage of terminology has some problem. But, the "device
hibernate" here means put device into quiescent state and save the
device state, but do not put device into low power state. 

> > 6. Reduce the boot-up time of kexec kernel. Maybe the kexec kernel can
> > be hibernate/resume by the normal kernel too. This way, a real
> > kexec/boot-up is only needed for the first time.
> 
> the hibernate kernel shouldn't need a lot of the features of the standard 
> kerneel (does it really need sound for example), and if tailored even 
> tighter could be configured to only have the drivers actually used for the 
> save and restore, makeing a _very_ minimal kernel (no USB, no network, 
> only simple video drivers, etc) greatly speeding up the boot

There is no need for two kernel. Most drivers and optional features are
compiled as modules, as that of most desktop distributions. So just
"insmod" needed modules only in hibernate kernel is sufficient.

Best Regards,
Huang Ying
