Return-Path: <linux-kernel-owner+w=401wt.eu-S1753593AbZKLRO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbZKLRO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 12:14:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326AbZKLROY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 12:14:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314AbZKLROX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 12:14:23 -0500
Date: Thu, 12 Nov 2009 12:13:56 -0500
From: Dave Jones <davej@redhat.com>
To: Thomas Renninger <trenn@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Zhao Yakui <yakui.zhao@intel.com>,
       Len Brown <lenb@kernel.org>
Subject: Re: linux-next: manual merge of the cpufreq tree with the acpi tree
Message-ID: <20091112171356.GC2447@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Thomas Renninger <trenn@suse.de>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, Zhao Yakui <yakui.zhao@intel.com>,
	Len Brown <lenb@kernel.org>
References: <20091112134524.d9854379.sfr@canb.auug.org.au>
 <200911120615.38067.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911120615.38067.trenn@suse.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 06:15:37AM -0600, Thomas Renninger wrote:
 
 > > evaluation status to the platform") from the acpi tree and commit
 > > b02d803d0fa3a395ba32bc5e5e3e7a3385ca7237 ("[CPUFREQ] Introduce bios_limit
 > > per cpu cpufreq sysfs interface") from the cpufreq tree.
 > First, thanks everybody for picking this up.
 
np, apologies for the delay.

 > > By the way, Dave, Thomas, shouldn't the second version of
 > > acpi_processor_get_bios_limit() in include/acpi/processor.h introduced by
 > > the above cpufreq tree patch be "static inline"?
 > Yes, good catch.
 > Shall I send an on top fix somewhere?

Yeah, an incremental will be fine. I'll fold it into the original.

thanks,

	Dave

