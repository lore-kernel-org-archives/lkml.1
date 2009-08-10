Return-Path: <linux-kernel-owner+w=401wt.eu-S932332AbZHJRC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332AbZHJRC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 13:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932323AbZHJRC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 13:02:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:36187 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932296AbZHJRC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 13:02:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,354,1246863600"; 
   d="scan'208";a="715475256"
Subject: Re: [patch 2/2] x86: arch specific support for remapping HPET MSIs
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: Ingo Molnar <mingo@elte.hu>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jay Fenlason <fenlason@redhat.com>
In-Reply-To: <20090808151254.GC28892@elte.hu>
References: <20090804190729.477649000@intel.com>
	 <20090804190729.630510000@intel.com>  <20090808151254.GC28892@elte.hu>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 10 Aug 2009 09:58:36 -0700
Message-Id: <1249923516.27006.10839.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-08-08 at 08:12 -0700, Ingo Molnar wrote:
> * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> 
> > x86 arch support for remapping HPET MSI's by associating the HPET 
> > timer block with the interrupt-remapping HW unit and setting up 
> > appropriate irq_chip
> 
> interesting. This means we'd materially utilize the irq-remapper not 
> just on relatively obscure, virtualization related setups, but also 
> in the native x86 bootup mode, on all (hpet+remap capable) Linux 
> systems?

Ingo, For native linux kernel, interrupt-remapping allows simple and
reliable irq migration from the process context (in addition to  its
need for supporting cpu's capable of x2apic). And as such solves the
issues we had in the past with cpu hotplug and irq migration.

> I like it - but i'll defer to Thomas to queue it up.

thanks,
suresh

