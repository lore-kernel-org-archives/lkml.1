Return-Path: <linux-kernel-owner+w=401wt.eu-S1757984AbZAVRVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbZAVRVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 12:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754378AbZAVRVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 12:21:31 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:22783 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbZAVRVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:21:31 -0500
Message-ID: <4978AB0C.4080801@oracle.com>
Date: Thu, 22 Jan 2009 09:21:16 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Greg KH <gregkh@suse.de>
Subject: Re: linux-next: Tree for January 22 (staging/rtl8187se)
References: <20090122180543.1ab0baa6.sfr@canb.auug.org.au> <4978A975.60002@oracle.com> <4978AA7F.5070306@oracle.com>
In-Reply-To: <4978AA7F.5070306@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4978AB0F.021A:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> Randy Dunlap wrote:
>> Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Changes since 20090121:
>>
>> drivers/staging/rtl8187se/r8180_core.c:5973: error: 'struct net_device' has no member named 'wireless_handlers'
>> drivers/staging/rtl8187se/r8180_core.c:5982: error: 'struct net_device' has no member named 'wireless_handlers'
>>
>>
> 
> and
> drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c:845: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
> drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c:852: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
> 


and
drivers/staging/rtl8187se/r8180_core.c: In function 'rtl8180_shutdown':
drivers/staging/rtl8187se/r8180_core.c:201: error: 'struct net_device' has no member named 'stop'
drivers/staging/rtl8187se/r8180_core.c: In function 'rtl8180_init':
drivers/staging/rtl8187se/r8180_core.c:4584: error: 'struct net_device' has no member named 'get_stats'
drivers/staging/rtl8187se/r8180_core.c: In function 'rtl8180_pci_probe':
drivers/staging/rtl8187se/r8180_core.c:5969: error: 'struct net_device' has no member named 'open'
drivers/staging/rtl8187se/r8180_core.c:5970: error: 'struct net_device' has no member named 'stop'
drivers/staging/rtl8187se/r8180_core.c:5972: error: 'struct net_device' has no member named 'tx_timeout'
drivers/staging/rtl8187se/r8180_core.c:5973: error: 'struct net_device' has no member named 'wireless_handlers'
drivers/staging/rtl8187se/r8180_core.c:5974: error: 'struct net_device' has no member named 'do_ioctl'
drivers/staging/rtl8187se/r8180_core.c:5975: error: 'struct net_device' has no member named 'set_multicast_list'
drivers/staging/rtl8187se/r8180_core.c:5976: error: 'struct net_device' has no member named 'set_mac_address'
drivers/staging/rtl8187se/r8180_core.c:5982: error: 'struct net_device' has no member named 'wireless_handlers'

-- 
~Randy
