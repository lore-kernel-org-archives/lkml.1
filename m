Return-Path: <linux-kernel-owner+w=401wt.eu-S1759128AbZFCPVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128AbZFCPVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 11:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753663AbZFCPUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 11:20:54 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:33225 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757352AbZFCPUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 11:20:52 -0400
Message-ID: <4A269539.8020607@oracle.com>
Date: Wed, 03 Jun 2009 08:22:33 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       johannes@sipsolutions.net,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: Tree for June 3 (rfkill)
References: <20090603190952.2dd0cc70.sfr@canb.auug.org.au>
In-Reply-To: <20090603190952.2dd0cc70.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt001.oracle.com [141.146.116.10]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.4A26947B.02E9:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Looks like a real rush since -rc7 ...


CFG80211=y
MAC80211=y
RFKILL=m

net/built-in.o: In function `cfg80211_netdev_notifier_call':
core.c:(.text+0xa678b): undefined reference to `rfkill_blocked'
net/built-in.o: In function `cfg80211_dev_free':
(.text+0xa67e2): undefined reference to `rfkill_destroy'
net/built-in.o: In function `cfg80211_rfkill_sync_work':
core.c:(.text+0xa686e): undefined reference to `rfkill_blocked'
net/built-in.o: In function `wiphy_new':
(.text+0xa69f2): undefined reference to `rfkill_alloc'
net/built-in.o: In function `wiphy_rfkill_start_polling':
(.text+0xa6bd2): undefined reference to `rfkill_resume_polling'
net/built-in.o: In function `wiphy_rfkill_stop_polling':
(.text+0xa6bdf): undefined reference to `rfkill_pause_polling'
net/built-in.o: In function `wiphy_unregister':
(.text+0xa6bf4): undefined reference to `rfkill_unregister'
net/built-in.o: In function `wiphy_rfkill_set_hw_state':
(.text+0xa6c64): undefined reference to `rfkill_set_hw_state'
net/built-in.o: In function `wiphy_register':
(.text+0xa6db4): undefined reference to `rfkill_register'
net/built-in.o: In function `cfg80211_wext_giwtxpower':
(.text+0xb01e9): undefined reference to `rfkill_blocked'
net/built-in.o: In function `cfg80211_wext_siwtxpower':
(.text+0xb0cf3): undefined reference to `rfkill_set_sw_state'
net/built-in.o: In function `cfg80211_wext_siwtxpower':
(.text+0xb0d1f): undefined reference to `rfkill_set_sw_state'


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
