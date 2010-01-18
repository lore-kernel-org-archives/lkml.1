Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855Ab0ARIHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab0ARIHR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 03:07:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668Ab0ARIHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 03:07:16 -0500
Received: from poutre.nerim.net ([62.4.16.124]:64946 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575Ab0ARIHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 03:07:15 -0500
Date: Mon, 18 Jan 2010 09:07:11 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Huaxu Wan <huaxu.wan@linux.intel.com>
Cc: Robert Hancock <hancockrwd@gmail.com>,
       Yuhong Bao <yuhongbao_386@hotmail.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, yong.y.wang@linux.intel.com
Subject: Re: [lm-sensors] [PATCH] hwmon: (coretemp) Fix TjMax for Atom 
 N450/D410/D510 CPUs
Message-ID: <20100118090711.5be2f70c@hyperion.delvare>
In-Reply-To: <20100118072138.GA25107@owl>
References: <20091224073102.GA23058@ywang-moblin2.bj.intel.com>
	<20100106160817.72313551@hyperion.delvare>
	<20100110200621.564a6682@hyperion.delvare>
	<20100111062024.GA20804@ywang-moblin2.bj.intel.com>
	<SNT125-W147C55AB6EB65D41CAAFFFC3680@phx.gbl>
	<20100117161518.4912be7c@hyperion.delvare>
	<4B536502.20102@gmail.com>
	<20100117210536.0ae0f187@hyperion.delvare>
	<20100118072138.GA25107@owl>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jan 2010 15:21:38 +0800, Huaxu Wan wrote:
> On 21:05 Sun 17 Jan, Jean Delvare wrote:
> > Anyway, how difficult would it be to set TjMax based on the CPUID? I
> > presume that the Intel Atom 400 and 500 series have their own CPUID
> > value, haven't they? This would seem even easier that checking for a
> > PCI device.
> 
> Actually, all the Atom processors share the same CPUID(0x1C) and the
> worse is not all of them has the same TjMax. That's a big problem. 

0x1C is the product value. The stepping value could be different. There
could also be other identification methods based on cpuid() or rdmsr()
commands. This is done quite frequently to identify specific CPU models.

-- 
Jean Delvare
