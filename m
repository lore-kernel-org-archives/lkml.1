Return-Path: <linux-kernel-owner+w=401wt.eu-S1752018AbZJIFT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbZJIFT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 01:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbZJIFTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 01:19:23 -0400
Received: from mga14.intel.com ([143.182.124.37]:30870 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbZJIFTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 01:19:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,530,1249282800"; 
   d="scan'208";a="196903077"
Subject: Re: [ERROR] drm:edid;  Unexpected error messages in syslog
From: ykzhao <yakui.zhao@intel.com>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Dave Airlie <airlied@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4ACAE592.8030307@bigpond.net.au>
References: <4ACAE592.8030307@bigpond.net.au>
Content-Type: text/plain
Organization: Intel Open Source Technology Center
Date: Fri, 09 Oct 2009 13:17:48 +0800
Message-Id: <1255065468.3601.24.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 14:37 +0800, Peter Williams wrote:
> I've started getting the following messages on recent kernels:
> 
> Oct  5 16:50:40 mudlark kernel: [drm:edid_is_valid] *ERROR* EDID 
> checksum is invalid, remainder is 16
> Oct  5 16:50:40 mudlark kernel: [drm:edid_is_valid] *ERROR* Raw EDID:
> Oct  5 16:50:40 mudlark kernel:
> Oct  5 16:50:40 mudlark kernel: i915 0000:00:02.0: VGA-1: EDID invalid.
> Oct  5 16:50:40 mudlark kernel: [drm:edid_is_valid] *ERROR* EDID 
> checksum is invalid, remainder is 16
> Oct  5 16:50:40 mudlark kernel: [drm:edid_is_valid] *ERROR* Raw EDID:
> Oct  5 16:50:40 mudlark kernel:
> Oct  5 16:50:40 mudlark kernel: i915 0000:00:02.0: VGA-1: EDID invalid.
> Oct  5 16:50:41 mudlark kernel: [drm] DAC-6: set mode 1600x1200 16
> Oct  5 16:50:45 mudlark kernel: [drm:edid_is_valid] *ERROR* EDID 
> checksum is invalid, remainder is 16
> Oct  5 16:50:45 mudlark kernel: [drm:edid_is_valid] *ERROR* Raw EDID:
> Oct  5 16:50:45 mudlark kernel:
> Oct  5 16:50:45 mudlark kernel: i915 0000:00:02.0: VGA-1: EDID invalid.
> Oct  5 16:50:45 mudlark kernel: [drm:edid_is_valid] *ERROR* EDID 
> checksum is invalid, remainder is 16
> Oct  5 16:50:45 mudlark kernel: [drm:edid_is_valid] *ERROR* Raw EDID:
> Oct  5 16:50:45 mudlark kernel:
> Oct  5 16:50:45 mudlark kernel: i915 0000:00:02.0: VGA-1: EDID invalid.
> Oct  5 16:50:45 mudlark kernel: [drm:edid_is_valid] *ERROR* EDID 
> checksum is invalid, remainder is 16
> Oct  5 16:50:45 mudlark kernel: [drm:edid_is_valid] *ERROR* Raw EDID:
> Oct  5 16:50:45 mudlark kernel:
> Oct  5 16:50:45 mudlark kernel: i915 0000:00:02.0: VGA-1: EDID invalid.
> Oct  5 16:51:00 mudlark kernel: [drm:edid_is_valid] *ERROR* EDID 
> checksum is invalid, remainder is 16
> Oct  5 16:51:00 mudlark kernel: [drm:edid_is_valid] *ERROR* Raw EDID:
> Oct  5 16:51:00 mudlark kernel:
> Oct  5 16:51:00 mudlark kernel: i915 0000:00:02.0: VGA-1: EDID invalid.
> Oct  5 16:51:00 mudlark kernel: [drm:edid_is_valid] *ERROR* EDID 
> checksum is invalid, remainder is 16
> Oct  5 16:51:00 mudlark kernel: [drm:edid_is_valid] *ERROR* Raw EDID:
> Oct  5 16:51:00 mudlark kernel:
> Oct  5 16:51:00 mudlark kernel: i915 0000:00:02.0: VGA-1: EDID invalid.
> Oct  5 16:51:00 mudlark kernel: [drm:edid_is_valid] *ERROR* EDID 
> checksum is invalid, remainder is 16
> Oct  5 16:51:00 mudlark kernel: [drm:edid_is_valid] *ERROR* Raw EDID:
> Oct  5 16:51:00 mudlark kernel:
> Oct  5 16:51:00 mudlark kernel: i915 0000:00:02.0: VGA-1: EDID invalid.
It seems that the EDID obtained from VGA monitor is incorrect.
Will you please open a new bug in
https://bugs.freedesktop.org/

and attach the output of dmesg, vbios.dump?
The vbios.dump can be obtained by using the following commands:
    echo 1 > /sys/devices/pci0000:00/0000:00:02.0/rom
    cat /sys/devices/pci0000:00/0000:00:02.0/rom > vbios.dump
    echo 0 > /sys/devices/pci0000:00/0000:00:02.0/rom

Thanks.
> 
> Should I worry about these?  There's no other noticeable problem with 
> the system.
> 
> Peter

