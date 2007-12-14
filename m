Return-Path: <linux-kernel-owner+w=401wt.eu-S1764131AbXLNWBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764131AbXLNWBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 17:01:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756467AbXLNWBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 17:01:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:50127 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862AbXLNWBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 17:01:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,169,1196668800"; 
   d="scan'208";a="238801929"
Date: Fri, 14 Dec 2007 14:00:15 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Dave Airlie <airlied@skynet.ie>
Cc: venkatesh.pallipadi@intel.com, ak@muc.de, ebiederm@xmission.com,
       rdreier@cisco.com, torvalds@linux-foundation.org, gregkh@suse.de,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/12] PAT 64b: PAT support for X86_64
Message-ID: <20071214220015.GD717@linux-os.sc.intel.com>
References: <20071213235543.568682000@intel.com> <alpine.DEB.0.82.0712140023550.27550@skynet.skynet.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.82.0712140023550.27550@skynet.skynet.ie>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 12:28:25AM +0000, Dave Airlie wrote:
> Yes, the main use for GPUs is to have RAM pages mapped WC, and placed into 
> a GART on the GPU side, currently for Intel IGD we are okay as the CPU can 
> access the GPU GART aperture, but other chips exist where this isn't 
> possible, I think poulsbo and possible some of the AMD IGPs..

Ok. So how is it working today on these platforms with no PAT support.
Open source drivers use UC or WB on these platforms? As this RAM is not
contiguous, one can't use MTRRs to set WC. Right?

Well, if WC is needed for RAM, then we have to address it too.

thanks,
suresh
