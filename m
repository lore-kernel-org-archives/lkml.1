Return-Path: <linux-kernel-owner+w=401wt.eu-S1757951AbYETBoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951AbYETBoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 21:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbYETBn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 21:43:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:20980 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507AbYETBn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 21:43:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,513,1204531200"; 
   d="scan'208";a="330120212"
Subject: Re: [BISECTED] pata_jmicron: no drives found on post 2.6.25 kernels
From: Shaohua Li <shaohua.li@intel.com>
To: Plamen Petrov <pvp-lsts@fs.ru.acad.bg>
Cc: linux-kernel@vger.kernel.org, Luca Tettamanti <kronos.it@gmail.com>
In-Reply-To: <courier.4832011A.000041C2@fs.ru.acad.bg>
References: <courier.4832011A.000041C2@fs.ru.acad.bg>
Content-Type: text/plain
Date: Tue, 20 May 2008 09:48:28 +0800
Message-Id: <1211248108.19834.2.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-20 at 01:37 +0300, Plamen Petrov wrote:
> Hello, folks! 
> 
> After 2.6.26 merge window opened, the optical drives in my
> computer, hanging off a JMicron controler were not detected
> by linux any more. 
> 
> Luca Tettamanti reported similar troubles:
> http://marc.info/?l=linux-kernel&m=120958791323911&w=2 
> 
> Its been 20 days, so I decided to bisect.
> git bisect revealed that commit
> 7d715a6c1ae5785d00fb9a876b5abdfc43abc44b
> is the one causing pata_jmicron to fail to detect drives,
> connected to the JMicron controler on my motherboard.
> At least in my case, anyway...
> Changing kernel config to CONFIG_PCIEASPM=n makes the drives
> attached to the JMicron SATA/PATA controller usable again. 
When you enable this option, did you change any ASPM policy? By default,
we are using the BIOS setting, so it shouldn't change any thing.

Also can you please send me the 'lspci -vvvxxxx' output with/without the
ASPM enabled?

Thanks,
Shaohua

