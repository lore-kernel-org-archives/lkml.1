Return-Path: <linux-kernel-owner+w=401wt.eu-S1761845AbXHKSGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761845AbXHKSGR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 14:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755006AbXHKSGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 14:06:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:16707 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbXHKSGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 14:06:08 -0400
Date: Sat, 11 Aug 2007 21:06:02 +0300
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: lenb@kernel.org, "Michael S. Tsirkin" <mst@dev.mellanox.co.il>,
       Hugh Dickins <hugh@veritas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] ACPI: thinkpad-acpi: change thinkpad-acpi input
	default and kconfig help
Message-ID: <20070811180602.GA17843@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <11868017142597-git-send-email-hmh@hmh.eng.br>
	<11868017143582-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11868017143582-git-send-email-hmh@hmh.eng.br>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Henrique de Moraes Holschuh <hmh@hmh.eng.br>:
> Subject: [PATCH 3/3] ACPI: thinkpad-acpi: change thinkpad-acpi input default and kconfig help
> 
> The current kconfig help text was misleading users.  Also, the default for
> an input-layer-optimized support caused way too many problems without
> up-to-date userspace in place.
> 
> So, rework the help text, and change the default to N.  Note that
> distributions are supposed to enable this option as soon as they update HAL
> to a version that handles the thinkpad-acpi new input layer interface.

I don't really know the details here, so I could be completely wrong.

However, generally, forcing HAL and kernel to be in sync really
looks to me like a non-ideal way to handle interface change.
For example, this would mean that one can't use the same kernel
for multiple distributions, and for a person like me
that needs to switch distros all the time, it seems like a pain.

Could not the kernel expose both new and old interfaces
somehow, so that HAL can be updated without recompiling the kernel?
For example, there could be a sysfs interface which let the HAL set
the desired interface version.

Couldn't that work?
This seems easy to code up.
Want a patch like that?

-- 
MST
