Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbYCLRIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbYCLRIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 13:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbYCLRIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 13:08:10 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:2681 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbYCLRIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 13:08:09 -0400
Date: Wed, 12 Mar 2008 18:08:02 +0100
From: Olivier Galibert <galibert@pobox.com>
To: Dave Jones <davej@codemonkey.org.uk>, Zhao Yakui <yakui.zhao@intel.com>,
       Li Shaohua <shaohua.li@intel.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Thomas Renninger <trenn@suse.de>, Len Brown <len.brown@intel.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: PNP: increase the maximum number of resources
Message-ID: <20080312170802.GA10606@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Dave Jones <davej@codemonkey.org.uk>,
	Zhao Yakui <yakui.zhao@intel.com>,
	Li Shaohua <shaohua.li@intel.com>,
	Bjorn Helgaas <bjorn.helgaas@hp.com>,
	Thomas Renninger <trenn@suse.de>, Len Brown <len.brown@intel.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20080312151452.GA4523@codemonkey.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080312151452.GA4523@codemonkey.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 11:14:52AM -0400, Dave Jones wrote:
> In commit a7839e960675b549f06209d18283d5cee2ce9261 the number of PNP resources
> was increased.  In testing, we've found that the 'exceeded' warnings still get
> hit with quite high frequency. See https://bugzilla.redhat.com/show_bug.cgi?id=436589
> for examples.
> 
> I added the debug patch below, which yielded an interesting output.
> 
> pnpacpi: exceeded the max number of mem resources. Max:12 Found:12
> 
> off by one somewhere ?

No, your patch is just not giving out any additional information.  'i'
is the number of currently allocated resources, not the number asked
for.  That number does not exist anywhere at that point as far as I
can see, you'll have to add a counter for it.

That looks valid for every resource type btw.

  OG.

