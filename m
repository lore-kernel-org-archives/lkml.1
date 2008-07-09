Return-Path: <linux-kernel-owner+w=401wt.eu-S1754147AbYGIRAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbYGIRAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 13:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbYGIRAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 13:00:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:48355 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbYGIRAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 13:00:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,332,1212390000"; 
   d="scan'208";a="350666570"
Date: Wed, 9 Jul 2008 10:00:06 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch] tip/x86_64: fix e820 merge issue which broke max_pfn_mapped
Message-ID: <20080709170005.GF1678@linux-os.sc.intel.com>
References: <20080708230837.GD1678@linux-os.sc.intel.com> <86802c440807081759i3baafa9bj7e8ff544a1a78fb9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807081759i3baafa9bj7e8ff544a1a78fb9@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2008 at 05:59:39PM -0700, Yinghai Lu wrote:
> On Tue, Jul 8, 2008 at 4:08 PM, Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> > With out this 64bit tip/master doesn't boot using ACPI on my system.
> > ---
> >
> > max_pfn_mapped should include all e820 entries.
> > The direct mapping extends to max_pfn_mapped, so that we can directly access
> > apertures, ACPI and other tables without having to play with fixmaps.
> >
> > With this, my system with 1GB memory boots fine with ACPI enabled.
> 
> so without this patch, your system doesn't boot?

It doesn't enable ACPI and hence doesn't bringup SMP etc etc..
