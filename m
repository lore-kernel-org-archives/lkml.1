Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbZHTVXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbZHTVXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 17:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755164AbZHTVXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 17:23:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:37084 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929AbZHTVXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 17:23:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,416,1246863600"; 
   d="scan'208";a="441249373"
Subject: Re: [PATCH] x86: add /proc/cpuinfo/physical id quirks
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alex Chiang <achiang@hp.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "mingo@redhat.com" <mingo@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090820210342.GC29994@basil.fritz.box>
References: <20090814163618.GQ7185@ldl.fc.hp.com>
	 <1250276831.3077.17.camel@sbs-t61.sc.intel.com>
	 <20090814192730.GA6431@ldl.fc.hp.com>
	 <1250279799.3077.41.camel@sbs-t61.sc.intel.com>
	 <20090819210251.GD13061@ldl.fc.hp.com>
	 <1250794594.2754.10.camel@sbs-t61.sc.intel.com>
	 <20090820205425.GF13061@ldl.fc.hp.com>
	 <20090820210342.GC29994@basil.fritz.box>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 20 Aug 2009 14:22:28 -0700
Message-Id: <1250803348.2754.26.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-20 at 14:03 -0700, Andi Kleen wrote:
> > I am leaning towards sysfs, and prefer:
> > 
> >  	/sys/devices/system/cpu/$cpu/chassis_id
> > 
> > How does that sound?
> 
> I would prefer to simply use the existing physical id for this like
> in your original patch.  We already have a bewildering zoo of different
> CPU IDs, no need to increase the confusion even more.
> 
> Incidentially mcelog already knows how to use physical ID for this,
> would need to be changed for a new sysfs interface

Andi, Based on our past experiences, I am nervous if there are some
software/firmware interactions that can negatively affect the cpu
topology detection.

If we really think overloading the "physical id" helps with existing
software, then I am ok with changing the user visible part of the /proc/
or /sys files but not with the kernel's per cpu info's phys_proc_id,
which is used for topology detection etc.

thanks,
suresh

