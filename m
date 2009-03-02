Return-Path: <linux-kernel-owner+w=401wt.eu-S1756701AbZCBTGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbZCBTGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 14:06:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbZCBTGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 14:06:25 -0500
Received: from mga09.intel.com ([134.134.136.24]:1345 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbZCBTGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 14:06:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,290,1233561600"; 
   d="scan'208";a="390961223"
Subject: Re: [TIP,regression,i915] /dev/dri/card0 is no longer present
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <20090301134809.GA4753@silver.sucs.org>
References: <20090301110455.GA18547@silver.sucs.org>
	 <20090301113948.GA3602@elte.hu>  <20090301134809.GA4753@silver.sucs.org>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 11:05:58 -0800
Message-Id: <1236020758.4586.76.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-01 at 05:48 -0800, Sitsofe Wheeler wrote:
> On Sun, Mar 01, 2009 at 12:39:48PM +0100, Ingo Molnar wrote:
> >
> > Thanks, i've reverted the commit for now. Could you please send
> > a 'dmesg' from the bootup with the failed driver? By all
> > likelyhood an ioremap failure causes a driver failure.
> >
> 
> See below (drm says it initalized though...):
> 
> [    0.000000] Linux version 2.6.29-rc6-00006-g17581ad (@verona) (gcc version 4.2.4) #87 Sun Mar 1 13:42:28 GMT 2009
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000] PAT WC disabled due to known CPU erratum.

Looks like PAT is getting disabled on this platform. Can you send the
output of /proc/cpuinfo please.

Thanks,
Venki

