Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917Ab0AFPIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab0AFPIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 10:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755900Ab0AFPIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 10:08:22 -0500
Received: from bamako.nerim.net ([62.4.17.28]:52462 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755886Ab0AFPIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 10:08:21 -0500
Date: Wed, 6 Jan 2010 16:08:17 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Yong Wang <yong.y.wang@linux.intel.com>
Cc: Rudolf Marek <r.marek@assembler.cz>, Huaxu Wan <huaxu.wan@intel.com>,
       lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: (coretemp) Fix TjMax for Atom N450/D410/D510
 CPUs
Message-ID: <20100106160817.72313551@hyperion.delvare>
In-Reply-To: <20091224073102.GA23058@ywang-moblin2.bj.intel.com>
References: <20091224073102.GA23058@ywang-moblin2.bj.intel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yong,

On Thu, 24 Dec 2009 15:31:02 +0800, Yong Wang wrote:
> The max junction temperature of Atom N450/D410/D510 CPUs is 100 degrees Celsius.
> Since these CPUs are always coupled with Intel NM10 chipset in one package, the
> best way to verify whether an Atom CPU is N450/D410/D510 is to check the host
> bridge device.
> 
> Signed-off-by: Yong Wang <yong.y.wang@intel.com>
> Acked-by: Huaxu Wan <huaxu.wan@intel.com>

Applied, thanks. I've also added a Kconfig dependency on CONFIG_PCI.

-- 
Jean Delvare
