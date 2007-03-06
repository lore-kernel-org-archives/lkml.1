Return-Path: <linux-kernel-owner+w=401wt.eu-S965148AbXCFPew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965148AbXCFPew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 10:34:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965150AbXCFPew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 10:34:52 -0500
Received: from mga02.intel.com ([134.134.136.20]:30305 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965148AbXCFPev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 10:34:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,254,1170662400"; 
   d="scan'208"; a="204697738:sNHT726479278"
Message-ID: <45ED8A12.5040803@intel.com>
Date: Tue, 06 Mar 2007 07:34:42 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Mail/News 1.5.0.9 (X11/20061228)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Kok, Auke" <auke-jan.h.kok@intel.com>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>, Pavel Machek <pavel@ucw.cz>,
       Jens Axboe <jens.axboe@oracle.com>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: SATA resume slowness, e1000 MSI warning
References: <20070227103021.GA2250@kernel.dk> <20070227103407.GA17819@elte.hu> <20070227105922.GD2250@kernel.dk> <20070227111515.GA4271@kernel.dk> <20070301093450.GA8508@elte.hu> <20070302100704.GB2293@elf.ucw.cz> <20070305084257.GA4464@mellanox.co.il> <20070305101120.GA23032@elte.hu> <45ECFC5F.7000102@garzik.org> <45ED0BBF.1050000@intel.com> <20070306090444.GA25409@elte.hu>
In-Reply-To: <20070306090444.GA25409@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Mar 2007 15:34:44.0774 (UTC) FILETIME=[F7415C60:01C76004]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Kok, Auke <auke-jan.h.kok@intel.com> wrote:
> 
>>>> BUG: at drivers/pci/msi.c:611 pci_enable_msi()
> 
>>> I would poke Eric Biederman(sp?) about this one.  Maybe its even 
>>> solved by the MSI-enable-related patch he posted in the past 24-48 
>>> hours.
>> I tried the 3-patch series "[PATCH 0/3] Basic msi bug fixes.." and 
>> they fix this problem for me. Were you expecting the OOPS in the first 
>> place? [...]
> 
> the bug was the warning message (a WARN_ON()) above - not an oops. So 
> that warning message is gone in your testing?

yes.

Auke
