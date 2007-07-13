Return-Path: <linux-kernel-owner+w=401wt.eu-S1762782AbXGMHXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762782AbXGMHXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 03:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755545AbXGMHXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 03:23:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:27125 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119AbXGMHW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 03:22:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,536,1175497200"; 
   d="scan'208";a="267783423"
Subject: Re: [PATCH][ACPI][BUTTON] remove procfs-interface
From: Zhang Rui <rui.zhang@intel.com>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Henne <henne@nachtwindheim.de>, Arjan van de Ven <arjan@infradead.org>,
       "Brown, Len" <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <a781481a0707121207o3497edbye9f89c9f2589f3e5@mail.gmail.com>
References: <4695F726.7030203@nachtwindheim.de>
	 <823A93EED437D048963A3697DB0E35DE7314AB@pdsmsx414.ccr.corp.intel.com>
	 <a781481a0707121207o3497edbye9f89c9f2589f3e5@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 13 Jul 2007 15:23:51 +0800
Message-Id: <1184311431.4427.12.camel@rzhang-crestline.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 (2.6.0-1) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jul 2007 07:22:51.0059 (UTC) FILETIME=[9EFF9830:01C7C51E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-13 at 03:07 +0800, Satyam Sharma wrote:
> On 7/12/07, Zhang, Rui <rui.zhang@intel.com> wrote:
> > Well, the ACPI sysfs conversion is not finished yet
> > [...]
> > I'm not sure if the button sysfs I/F is already finished.
> > We'd better make a double check. :)
> 
> Ok, this sounds reasonable.
> 
> > and some user space tools still use the ACPI procfs.
> 
> But this does *not*, IMHO. It quite defeats the whole concept of
> feature-removal-schedule.txt. I think that file exists precisely
> because we cannot gratuitously break userspace interfaces just
> like that, but when something gets put up there with a removal date
> that is a good one year in the future, and userspace tools _still_
> continue to use it ... then, I suspect something's seriously wrong.
> 
Hi, Satyam,
Here I mean the sysfs conversion is not finished, like some ACPI
device/driver attributes.
i.e. we don't have the alternative in sysfs for all the ACPI proc I/F,
which means that part of the ACPI proc I/F are still needed.

> Either the feature-removal-schedule.txt file has become something
> that users don't even bother checking, or else, they _know_ that
> even if they don't bother keeping up with the pace in kernel-land,
> that interface still won't go away (because they're still using it!).
> In both the above cases, it appears that file itself has become
> irrelevant and a "feature" that could be "removed" ... :-)

Thanks,
Rui
