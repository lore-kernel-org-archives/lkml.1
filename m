Return-Path: <linux-kernel-owner+w=401wt.eu-S1758176AbZBBUmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176AbZBBUmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 15:42:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754803AbZBBUmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 15:42:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:43261 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754610AbZBBUmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 15:42:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,366,1231142400"; 
   d="scan'208";a="383304434"
Subject: Re: linux-next: Tree for February 2 (iwlwifi)
From: reinette chatre <reinette.chatre@intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090202103401.a189e8e0.randy.dunlap@oracle.com>
References: <20090202201637.28896d2f.sfr@canb.auug.org.au>
	 <20090202103401.a189e8e0.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Mon, 02 Feb 2009 12:45:23 -0800
Message-Id: <1233607523.2411.174.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-02 at 10:34 -0800, Randy Dunlap wrote:
> On Mon, 2 Feb 2009 20:16:37 +1100 Stephen Rothwell wrote:
> 
> > Hi all,
> >
> > Changes since 20090126:
> 
> 
> a.  optional drivers such as iwlwifi should not default to 'y':
> 
> config IWLWIFI
>         bool "Intel Wireless Wifi"
>         depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
>         default y

will fix.

> 
> b.  Are there cases where IWLCORE is not needed?  I.e., why is it
> even a kconfig option?

indeed ... now that 3945 depends on IWLCORE also we could replace
IWLWIFI with it because IWLWIFI is not used in code ... we will have to
see if this is possible.

> 
> 
> c.  The attached config causes beaucoup build errors with:
> CONFIG_IWLWIFI=y
> # CONFIG_IWLCORE is not set
> # CONFIG_IWLAGN is not set
> CONFIG_IWL3945=y
> # CONFIG_IWL3945_SPECTRUM_MEASUREMENT is not set
> CONFIG_IWL3945_LEDS=y

3945 is being ported to iwlwifi and we neglected to change Kconfig to
reflect this. We will fix it.

Thank you very much for this report.

Reinette


