Return-Path: <linux-kernel-owner+w=401wt.eu-S1752593AbYIXKxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbYIXKxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 06:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbYIXKxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 06:53:36 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:32894 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbYIXKxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 06:53:35 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48DA1B95.5030806@s5r6.in-berlin.de>
Date: Wed, 24 Sep 2008 12:51:01 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: jkosina@suse.cz, jeffrey.t.kirsher@intel.com, jeff@garzik.org,
       mingo@elte.hu, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       jesse.brandeburg@intel.com, john.ronciak@intel.com,
       bruce.w.allan@intel.com
Subject: Re: [PATCH 2/3] e1000e: Useset_memory_ro()/set_memory_rw() to protect
 flash memory
References: <20080923224535.6869.76210.stgit@jtkirshe-mobile.jf.intel.com>	<20080923.162957.141669474.davem@davemloft.net>	<Pine.LNX.4.64.0809240142030.27884@twin.jikos.cz> <20080923.164745.12711639.davem@davemloft.net>
In-Reply-To: <20080923.164745.12711639.davem@davemloft.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Jiri Kosina <jkosina@suse.cz>
> Date: Wed, 24 Sep 2008 01:45:53 +0200 (CEST)
> 
>> Yes, probably not a vanilla kernel material, but could be very well used 
>> for testing to further isolate whether it is kernel or userspace 
>> corrupting the memory mapped eeprom.
> 
> Absolutely.

Would it help and would it be feasible to drastically shorten the 
lifetime of the MMIO mapping?  I.e. only have it mapped briefly during 
the driver probe, and temporarily whenever a userspace tool like ethtool 
needs it.
-- 
Stefan Richter
-=====-==--- =--= ==---
http://arcgraph.de/sr/
