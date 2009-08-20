Return-Path: <linux-kernel-owner+w=401wt.eu-S932104AbZHTVMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbZHTVMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 17:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbZHTVMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 17:12:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:64700 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213AbZHTVMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 17:12:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,416,1246863600"; 
   d="scan'208";a="485747864"
Subject: Re: [PATCH] x86: add /proc/cpuinfo/physical id quirks
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Alex Chiang <achiang@hp.com>
Cc: "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090820205425.GF13061@ldl.fc.hp.com>
References: <20090814163618.GQ7185@ldl.fc.hp.com>
	 <1250276831.3077.17.camel@sbs-t61.sc.intel.com>
	 <20090814192730.GA6431@ldl.fc.hp.com>
	 <1250279799.3077.41.camel@sbs-t61.sc.intel.com>
	 <20090819210251.GD13061@ldl.fc.hp.com>
	 <1250794594.2754.10.camel@sbs-t61.sc.intel.com>
	 <20090820205425.GF13061@ldl.fc.hp.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 20 Aug 2009 14:11:20 -0700
Message-Id: <1250802680.2754.15.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-20 at 13:54 -0700, Alex Chiang wrote:
> To me, the BIOS concerns are moot. I work closely with the BIOS
> engineers for this platform; I have knowledge of future plans for
> this BIOS and platform; and I know that they will not make any
> changes that break the assumptions in my patch.
> 
> If they do, we will catch it during platform testing, file a bug,
> and not let them release their BIOS until it's fixed. Does that
> satisfy you? :)
> 
> So the algorithm for mapping an APIC ID to a physical/chassis ID
> for this platform will not ever change.

What happens if there is some genuine reason to do that because of some
other platform workaround etc?


> I am leaning towards sysfs, and prefer:
> 
>  	/sys/devices/system/cpu/$cpu/chassis_id
> 

Looks fine to me.

thanks,
suresh

