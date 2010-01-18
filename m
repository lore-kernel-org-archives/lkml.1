Return-Path: <linux-kernel-owner+w=401wt.eu-S1753067Ab0ARHRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab0ARHRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 02:17:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214Ab0ARHRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 02:17:44 -0500
Received: from mga05.intel.com ([192.55.52.89]:1030 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751715Ab0ARHRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 02:17:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,292,1262592000"; 
   d="scan'208";a="765058437"
Date: Mon, 18 Jan 2010 15:21:38 +0800
From: Huaxu Wan <huaxu.wan@linux.intel.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Robert Hancock <hancockrwd@gmail.com>, huaxu.wan@intel.com,
       Yuhong Bao <yuhongbao_386@hotmail.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, yong.y.wang@linux.intel.com
Subject: Re: [lm-sensors] [PATCH] hwmon: (coretemp) Fix TjMax for Atom
 N450/D410/D510 CPUs
Message-ID: <20100118072138.GA25107@owl>
References: <20091224073102.GA23058@ywang-moblin2.bj.intel.com>
 <20100106160817.72313551@hyperion.delvare>
 <20100110200621.564a6682@hyperion.delvare>
 <20100111062024.GA20804@ywang-moblin2.bj.intel.com>
 <SNT125-W147C55AB6EB65D41CAAFFFC3680@phx.gbl>
 <20100117161518.4912be7c@hyperion.delvare>
 <4B536502.20102@gmail.com>
 <20100117210536.0ae0f187@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100117210536.0ae0f187@hyperion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21:05 Sun 17 Jan, Jean Delvare wrote:
> On Sun, 17 Jan 2010 13:29:06 -0600, Robert Hancock wrote:
> > On 01/17/2010 09:15 AM, Jean Delvare wrote:
> > > On Fri, 15 Jan 2010 18:02:27 -0800, Yuhong Bao wrote:
> > >>
> > >>> No matter what chipset or gfx you use with the new Atom chip, the
> > >>> integrated memory controller (IMC) will always be used. This patch
> > >>> checks the presence of that IMC. Hope this clarifies.
> > >> To be more precise, Pine Trail Atoms integrate the entire northbridge, including the integrated graphics and the memory controller into the CPU, and there is a DMI connection to the southbridge, which is the Intel NM10, that is NOT integrated.
> > >
> > > What prevents another vendor from selling a compatible south bridge
> > > then?
> > 
> > Nothing (other than licensing for the DMI bus, see NVIDIA and the 
> > problems this creates for their ION chipset). I'm assuming this patch is 
> > checking for the host bridge device though, that is integrated into the 
> > CPU and would always be present.
> 
> That's where I am confused. The patch checks for the presence of the
> Intel NM10, which, reading its description looks much like a south
> bridge and not a memory controller (north bridge). So I think the patch
> is wrong (or at least incomplete).
> 
> Anyway, how difficult would it be to set TjMax based on the CPUID? I
> presume that the Intel Atom 400 and 500 series have their own CPUID
> value, haven't they? This would seem even easier that checking for a
> PCI device.

Actually, all the Atom processors share the same CPUID(0x1C) and the
worse is not all of them has the same TjMax. That's a big problem. 

Thanks
Huaxu
