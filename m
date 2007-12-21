Return-Path: <linux-kernel-owner+w=401wt.eu-S1756392AbXLUTud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392AbXLUTud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 14:50:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753758AbXLUTuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 14:50:25 -0500
Received: from tomts52-srv.bellnexxia.net ([209.226.175.177]:55699 "EHLO
	tomts52-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753497AbXLUTuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 14:50:24 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAC+oa0dFn+Sr/2dsb2JhbACRVZg6Aw
Date: Fri, 21 Dec 2007 14:50:19 -0500
From: Mike Houston <mikeserv@bmts.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jean Delvare <khali@linux-fr.org>, Shaohua Li <shaohua.li@intel.com>,
       Mike Houston <mikeserv@bmts.com>, Adrian Bunk <bunk@stusta.de>,
       Elvis Pranskevichus <el@prans.net>, mhoffman@lightlink.com,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       Adam Belay <ambx1@neo.rr.com>, Zhao Yakui <yakui.zhao@intel.com>,
       Thomas Renninger <trenn@suse.de>, lenb@kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [lm-sensors] 2.6.24-rc4 hwmon it87 probe fails
Message-Id: <20071221145019.b853c67e.mikeserv@bmts.com>
In-Reply-To: <200712211200.30947.bjorn.helgaas@hp.com>
References: <20071204215154.7f26285e.mikeserv@bmts.com>
	<200712171014.44360.bjorn.helgaas@hp.com>
	<20071218185918.5d2d4c7d@hyperion.delvare>
	<200712211200.30947.bjorn.helgaas@hp.com>
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.10.14; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2007 12:00:30 -0700
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> What do you think of something like the following patch?  If we do
> this, I don't think we'd need to force pnpacpi=off or change the
> way PNP reserves resources.
> 
> I'll be on vacation until about January 2, so I won't be able to
> do much with this until then.
> 
> 
> 
> [patch] it87: request only Environment Controller ports

I'm not qualified to give an opinion on what's proper for the
kernel, so all I can say is that I've applied it (to fresh 2.6.24-rc6
source without Shaohua's pnpacpi patch) and it works nicely for me.

>From /proc/ioports:

0290-029f : pnp 00:01
  0290-0294 : pnp 00:01
  0295-0296 : it87
    0295-0296 : it87

>From dmesg:

system 00:01: ioport range 0x290-0x29f has been reserved
...
system 00:01: ioport range 0x290-0x294 has been reserved

My sensors work.

Thanks for this patch,

Mike Houston
