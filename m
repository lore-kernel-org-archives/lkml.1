Return-Path: <linux-kernel-owner+w=401wt.eu-S933913AbXK3IEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933913AbXK3IEb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 03:04:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932348AbXK3IER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 03:04:17 -0500
Received: from mga11.intel.com ([192.55.52.93]:61123 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754632AbXK3IEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 03:04:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,233,1194249600"; 
   d="scan'208";a="409066938"
Subject: Re: pnpacpi : exceeded the max number of IO resources
From: Zhao Yakui <yakui.zhao@intel.com>
To: Valdis.Kletnieks@vt.edu
Cc: Dave Young <hidave.darkstar@gmail.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <22018.1196404859@turing-police.cc.vt.edu>
References: <a8e1da0711290111m65b071cft90b4361ec0155096@mail.gmail.com>
	 <a8e1da0711291718u4161e650g1ee7eb88243ed9a4@mail.gmail.com>
	 <1196389288.19722.29.camel@yakui_zhao.sh.intel.com>
	 <22018.1196404859@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Fri, 30 Nov 2007 16:14:14 +0800
Message-Id: <1196410454.19722.39.camel@yakui_zhao.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-30 at 01:40 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 30 Nov 2007 10:21:28 +0800, Zhao Yakui said:
> > Thanks for the acpidump & dmesg.
> > 	In the acpidump there are so many IO resource definitions in the device
> > of mem2 and the number exceeds the predefined number(24).
> 
> On a semi-related note, I'm seeing 7 of these at each boot on a Dell Latitude D820:
> 
> pnpacpi: exceeded the max number of mem resources: 12
> 
> 2.6.24-rc3-mm2 does it, it didn't do it for 2.6.23-mm1.
> 
> pnp-increase-the-maximum-number-of-resources.patch raised it from 4 to 12, but
> I don't understand why it didn't complain at 4 in 23-mm1, but it does at 12 now.
In the 23-mm1 there is no such debug info. When the number of mem
resource (for one Pnp device) defined by BIOS exceeds the predefined
constant, the mem resource can't be added. But it won't report this
case. 
In the 24-mm2 the PnP constant is raised and the debug info is added.
When the number exceeds the predifined constant, it will give the debug
info. 

Thanks.
> 
