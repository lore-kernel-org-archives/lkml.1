Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116Ab0AQPPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab0AQPPW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 10:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971Ab0AQPPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 10:15:22 -0500
Received: from bamako.nerim.net ([62.4.17.28]:59265 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885Ab0AQPPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 10:15:21 -0500
Date: Sun, 17 Jan 2010 16:15:18 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Yuhong Bao <yuhongbao_386@hotmail.com>
Cc: <yong.y.wang@linux.intel.com>, <linux-kernel@vger.kernel.org>,
       <huaxu.wan@intel.com>, <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH] hwmon: (coretemp) Fix TjMax for Atom 
 N450/D410/D510 CPUs
Message-ID: <20100117161518.4912be7c@hyperion.delvare>
In-Reply-To: <SNT125-W147C55AB6EB65D41CAAFFFC3680@phx.gbl>
References: <20091224073102.GA23058@ywang-moblin2.bj.intel.com>
	<20100106160817.72313551@hyperion.delvare>
	<20100110200621.564a6682@hyperion.delvare>
	<20100111062024.GA20804@ywang-moblin2.bj.intel.com>
	<SNT125-W147C55AB6EB65D41CAAFFFC3680@phx.gbl>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jan 2010 18:02:27 -0800, Yuhong Bao wrote:
> 
> > No matter what chipset or gfx you use with the new Atom chip, the
> > integrated memory controller (IMC) will always be used. This patch
> > checks the presence of that IMC. Hope this clarifies.
> To be more precise, Pine Trail Atoms integrate the entire northbridge, including the integrated graphics and the memory controller into the CPU, and there is a DMI connection to the southbridge, which is the Intel NM10, that is NOT integrated.

What prevents another vendor from selling a compatible south bridge
then?

I start believing that we'd rather identify these Atom models using
CPUID rather than a PCI device.

-- 
Jean Delvare
