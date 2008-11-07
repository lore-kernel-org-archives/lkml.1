Return-Path: <linux-kernel-owner+w=401wt.eu-S1754763AbYKGF7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbYKGF7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 00:59:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbYKGF6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 00:58:50 -0500
Received: from waste.org ([66.93.16.53]:36253 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbYKGF6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 00:58:50 -0500
Subject: Re: iwlagn: wrong command queue 31, command id 0x0
From: Matt Mackall <mpm@selenic.com>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: Zhu Yi <yi.zhu@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <5109BB99-53F1-499A-9D0B-FAB77591FBD5@linux.intel.com>
References: <1225944979.3792.3.camel@calx>
	 <5109BB99-53F1-499A-9D0B-FAB77591FBD5@linux.intel.com>
Content-Type: text/plain
Date: Thu, 06 Nov 2008 23:58:38 -0600
Message-Id: <1226037518.3023.60.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-07 at 05:40 +0100, Marcel Holtmann wrote:
> Hi Matt,
> 
> > [ 5470.869820] WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1204
> > iwl_rx_handle+0x11a/0x21b [iwlagn]()
> > [ 5470.869824] wrong command queue 31, command id 0x0
> 
> I am seeing this a lot with my X61 running a 64-bit kernel/OS and my D- 
> Link DIR-615 access point. With some other access points I am seeing  
> it never or a lot less.

> What kind of laptop and access point are you using? Is you access  
> point 802.11n capable? Do you run the i386 or x86_64 version of your  
> distro?

Laptop is a Fujitsu 8010p. I've tried this with kernel only once with a
G-capable Airport (with various other unknown access points in range),
but it failed to find any networks. 64-bit kernel and Debian unstable.

2.6.27 mostly works fine here, though occasionally I need to load/unload
iwlagn after s2ram.

-- 
Mathematics is the supreme nostalgia of our time.

