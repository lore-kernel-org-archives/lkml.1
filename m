Return-Path: <linux-kernel-owner+w=401wt.eu-S1754629AbXFXAdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbXFXAdN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 20:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbXFXAdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 20:33:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:51314 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850AbXFXAdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 20:33:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,455,1175497200"; 
   d="scan'208";a="258078753"
Date: Sat, 23 Jun 2007 17:28:36 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de
Subject: Re: Device hang when offlining a CPU due to IRQ misrouting
Message-ID: <20070624002836.GB25516@linux-os.sc.intel.com>
References: <20070606231642.GH13751@tree.beaverton.ibm.com> <20070619204929.GM9751@tree.beaverton.ibm.com> <20070619220812.GG7160@linux-os.sc.intel.com> <200706240154.53351.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706240154.53351.rjw@sisk.pl>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2007 at 01:54:52AM +0200, Rafael J. Wysocki wrote:
> This patch breaks hibernation on my Turion 64 X2 - based testbox (HPC nx6325).
> 
> _cpu_down() just hangs as though there were a deadlock in there, 100% of the
> time.

Does the patch at this URL work for you?

http://marc.info/?l=linux-kernel&m=118228358826737&w=2

thanks,
suresh
