Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbZD0RNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbZD0RNv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 13:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755788AbZD0RN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 13:13:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:58706 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229AbZD0RN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 13:13:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,255,1239001200"; 
   d="scan'208";a="510302389"
Subject: Re: 2.6.30-rc3: iwlagn probe timeouts (regression)
From: reinette chatre <reinette.chatre@intel.com>
To: Niel Lambrechts <niel.lambrechts@gmail.com>
Cc: "linux.kernel" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <49F4F5B1.4020201@gmail.com>
References: <49F4F5B1.4020201@gmail.com>
Content-Type: text/plain
Date: Mon, 27 Apr 2009 10:19:37 -0700
Message-Id: <1240852777.29221.6.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Niel,

On Sun, 2009-04-26 at 17:00 -0700, Niel Lambrechts wrote:
> Hi,
> 
> In earlier 2.6.30 (rc1 and 2) kernel tests I suffered the "beacon loss,
> sending probe request" problem, during which my connection would
> intermittently fail and reconnect. With the latest git kernel which
> seems to include a patch (ad935687dbe7307f5abd9e3f610a965a287324a9) for
> at least some of this, my card (Intel 5300AGN REV=0x24) completely fails
> to associate and I get:
> 
> Apr 27 01:32:36 linux-7vph kernel: Registered led device: iwl-phy0::radio
> Apr 27 01:32:36 linux-7vph kernel: Registered led device: iwl-phy0::assoc
> Apr 27 01:32:36 linux-7vph kernel: Registered led device: iwl-phy0::RX
> Apr 27 01:32:36 linux-7vph kernel: Registered led device: iwl-phy0::TX
> Apr 27 01:32:36 linux-7vph kernel: ADDRCONF(NETDEV_UP): wlan0: link is
> not ready
> Apr 27 01:32:40 linux-7vph sudo:   niella : TTY=pts/2 ; PWD=/home/niella
> ; USER=root ; COMMAND=/usr/bin/tail -f /var/log/messages
> Apr 27 01:33:16 linux-7vph kernel: wlan0: direct probe to AP
> 00:1d:92:1d:1e:8e try 1
> Apr 27 01:33:16 linux-7vph kernel: wlan0: direct probe to AP
> 00:1d:92:1d:1e:8e try 2
> Apr 27 01:33:16 linux-7vph kernel: wlan0: direct probe to AP
> 00:1d:92:1d:1e:8e try 3
> Apr 27 01:33:16 linux-7vph kernel: wlan0: direct probe to AP
> 00:1d:92:1d:1e:8e timed out
> Apr 27 01:33:29 linux-7vph kernel: wlan0: direct probe to AP
> 00:1d:92:1d:1e:8e try 1
> Apr 27 01:33:29 linux-7vph kernel: wlan0: direct probe to AP
> 00:1d:92:1d:1e:8e try 1
> Apr 27 01:33:29 linux-7vph kernel: wlan0: direct probe to AP
> 00:1d:92:1d:1e:8e try 2
> Apr 27 01:33:29 linux-7vph kernel: wlan0: direct probe to AP
> 00:1d:92:1d:1e:8e try 3
> Apr 27 01:33:29 linux-7vph kernel: wlan0: direct probe to AP
> 00:1d:92:1d:1e:8e timed out
> Apr 27 01:33:42 linux-7vph kernel: wlan0: direct probe to AP
> 00:1d:92:1d:1e:8e try 1
> Apr 27 01:33:42 linux-7vph kernel: wlan0: direct probe to AP
> 00:1d:92:1d:1e:8e try 1
> Apr 27 01:33:42 linux-7vph kernel: wlan0: direct probe to AP
> 00:1d:92:1d:1e:8e try 2
> Apr 27 01:33:42 linux-7vph kernel: wlan0: direct probe to AP
> 00:1d:92:1d:1e:8e try 3
> Apr 27 01:33:43 linux-7vph kernel: wlan0: direct probe to AP
> 00:1d:92:1d:1e:8e timed out
> 
> I do not have any similar problems with 2.6.29 or 2.6.28 at the exact
> same physical location.
> 
> I can try to bisect in a day or two if need be.

>From what I can tell we did not send any iwlagn patches to 2.6.30 that
are related to this behavior. Please do try a bisect. 

Thank you

Reinette


