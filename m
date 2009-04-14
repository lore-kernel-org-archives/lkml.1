Return-Path: <linux-kernel-owner+w=401wt.eu-S1758935AbZDNSyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935AbZDNSyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757005AbZDNSyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:54:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:30586 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756537AbZDNSyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:54:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,186,1239001200"; 
   d="scan'208";a="506420639"
Subject: Re: [Ipw2100-admin] [BUILD FAILURE 04/12] Next April 14 : PPC64
 randconfig [drivers/staging/built-in.o]
From: reinette chatre <reinette.chatre@intel.com>
To: "subrata@linux.vnet.ibm.com" <subrata@linux.vnet.ibm.com>
Cc: "James P. Ketrenos" <ipw2100-admin@linux.intel.com>,
       Andrea Merello <andreamrl@tiscali.it>,
       Linuxppc-dev <Linuxppc-dev@ozlabs.org>, Greg KH <greg@kroah.com>,
       sachinp <sachinp@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-next <linux-next@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>
In-Reply-To: <1239733717.5344.76.camel@subratamodak.linux.ibm.com>
References: <1239733717.5344.76.camel@subratamodak.linux.ibm.com>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 11:59:55 -0700
Message-Id: <1239735595.15115.60.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Subrata,

On Tue, 2009-04-14 at 11:28 -0700, Subrata Modak wrote:
> Observed the following build error:
> ---
> LD      drivers/built-in.o
> drivers/staging/built-in.o: In function `ieee80211_xmit':
> drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c:528: multiple
> definition of `ieee80211_xmit'
> drivers/net/built-in.o:drivers/net/wireless/ipw2x00/libipw_tx.c:256:
> first defined here
> make[1]: *** [drivers/built-in.o] Error 1
> make: *** [drivers] Error 2

Looks like the rtl8187se driver started with a copy of ipw2x00's
library. Errors like this can thus be expected and should be addressed
by rtl8187se as they are the ones who made the copy.

Reinette

