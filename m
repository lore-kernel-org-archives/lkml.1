Return-Path: <linux-kernel-owner+w=401wt.eu-S1755700AbZIRICS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700AbZIRICS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 04:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755480AbZIRICQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 04:02:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:52589 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754530AbZIRICO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 04:02:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,408,1249282800"; 
   d="scan'208";a="551681264"
Date: Fri, 18 Sep 2009 15:59:01 +0800
From: Alek Du <alek.du@intel.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "david-b@pacbell.net" <david-b@pacbell.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] gpio: add Intel Moorestown Platform Langwell chip
 gpio driver
Message-ID: <20090918155901.29eb0871@dxy.sh.intel.com>
In-Reply-To: <20090918074951.GA4075@flint.arm.linux.org.uk>
References: <20090703210706.41288a2a@dxy.sh.intel.com>
	<20090917163644.4783a337.akpm@linux-foundation.org>
	<20090918091844.6c8a8bd1@dxy.sh.intel.com>
	<20090917203826.e083746d.akpm@linux-foundation.org>
	<20090918074951.GA4075@flint.arm.linux.org.uk>
Organization: Intel Corp.
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.1; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Sep 2009 15:49:51 +0800
Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> 
> Ever since ARM was converted over to genirq, I've given up fighting it.
> It does still mean that any arch not using genirq is going to have
> problems with these drivers.
> 
> I suspect that it's still the case that many of these includes should
> be linux/interrupt.h and not linux/irq.h
> 

I have included linux/interrupt.h, but it failed for sparc64 building. So I have to
send the patch to add linux/irq.h.

Thanks,
Alek
