Return-Path: <linux-kernel-owner+w=401wt.eu-S1753170AbZC0Vmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbZC0Vmu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 17:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbZC0Vml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 17:42:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:31147 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbZC0Vmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 17:42:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,434,1233561600"; 
   d="scan'208";a="501441415"
Subject: Re: [ipw3945-devel] Problem on connecting on iwl3945 wifi card
From: reinette chatre <reinette.chatre@intel.com>
To: Andrey Batyiev <batyiev@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <200903201843.06190.batyiev@gmail.com>
References: <200903201843.06190.batyiev@gmail.com>
Content-Type: text/plain
Date: Fri, 27 Mar 2009 14:48:10 -0700
Message-Id: <1238190490.25568.92.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-20 at 09:43 -0700, Andrey Batyiev wrote:
> Hello
> 
> I'm using 2.6.28.7 and driver requests iwlwifi-3945-1.ucode firmware. I'm trying 
> to connect by my wifi card and get the following in syslog:
> 
> Mar 20 18:10:30 localhost kernel: [ 1531.002769] wlan0: Selected IBSS BSSID 
> 00:ed:3f:ed:94:00 based on configured SSID
> Mar 20 18:10:30 localhost kernel: [ 1531.008142] ------------[ cut here 
> ]------------
> Mar 20 18:10:30 localhost kernel: [ 1531.008147] WARNING: at 
> net/mac80211/main.c:159 ieee80211_if_config+0x24/0x128()

Please check that your interface is up (ip link set wlan0 up) first.

Reinette


