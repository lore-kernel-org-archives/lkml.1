Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbYIKQUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbYIKQUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 12:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbYIKQUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 12:20:09 -0400
Received: from senator.holtmann.net ([87.106.208.187]:47614 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbYIKQUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 12:20:08 -0400
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Faidon Liambotis <paravoid@debian.org>
Cc: David Miller <davem@davemloft.net>, dwmw2@infradead.org, jeffm@suse.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
In-Reply-To: <48C8BC17.5050508@debian.org>
References: <48C68507.6000609@suse.com>
	 <1221087719.13621.50.camel@macbook.infradead.org>
	 <20080910.160505.14060698.davem@davemloft.net>
	 <48C8BC17.5050508@debian.org>
Content-Type: text/plain
Date: Thu, 11 Sep 2008 18:20:37 +0200
Message-Id: <1221150037.6309.41.camel@californication>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Faidon,

> >> Firmware really _isn't_ version-specific.
> > 
> > Tell that to every Debian and Debian derived system on the planet.
> > 
> > To my knowledge, it is only fedora and possibly one or two other dists
> > that put the firmware files in a unary /lib/firmware location, rather
> > than a versioned /lib/firmware/$KERNELRELASE one.
> [not speaking on behalf of the project, the kernel team or the
> respective maintainers]
> 
> Apparently and afaik you are misinformed:
> 
> $ dpkg -L firmware-bnx2 (or [1])
> ...
> /lib/firmware/bnx2-06-4.0.5.fw
> /lib/firmware/bnx2-09-4.0.5.fw
> ...
> 
> $ dpkg -L firmware-iwlwifi (or [2])
> ...
> /lib/firmware/iwlwifi-3945-1.ucode
> /lib/firmware/iwlwifi-4965-1.ucode
> /lib/firmware/iwlwifi-4965-2.ucode
> ...

that is different. It is the version of the firmware. It doesn't depend
on the version of the Linux kernel. Yes, there is a tiny dependency on
the kernel, but that comes from the driver requirements and we would
have MODULE_FIRMWARE to clearly indicate which drivers needs which
firmware.

Tying it to the kernel version is wrong. It depends on the version of
the driver.

Regards

Marcel


