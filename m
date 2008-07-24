Return-Path: <linux-kernel-owner+w=401wt.eu-S1755121AbYGXUN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbYGXUN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 16:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbYGXUNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 16:13:16 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:56296 "EHLO
	pd6mo1no-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752679AbYGXUNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 16:13:14 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=_o6xf00tTMQv3HhadDoA:9 a=vfXOTUosYJvBRihhNqmzyuToiPYA:4 a=umgxVUcCkn4A:10 a=r8049craAYIA:10
Message-ID: <4888E253.1020401@shaw.ca>
Date: Thu, 24 Jul 2008 14:13:07 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Peter Zijlstra <peterz@infradead.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Pierre Ossman <drzeus-list@drzeus.cx>,
       "John W. Linville" <linville@tuxdriver.com>,
       Jean Tourrilhes <jt@hpl.hp.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 22bb1be4d27... breaks hal (and NM)
References: <fa.M1pe2GT5+zpRaz/wfP7Zjo6SOMU@ifi.uio.no> <fa.oiNbP36FW/6wru8zoq8SWBE4P+Y@ifi.uio.no> <fa.iZfkeomZo5PN4BBKKgjtHjkkGnw@ifi.uio.no> <fa.cRAFIbCK4bQBxVGv6jJ9s6e4C4M@ifi.uio.no>
In-Reply-To: <fa.cRAFIbCK4bQBxVGv6jJ9s6e4C4M@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> : +config WIRELESS_EXT_SYSFS
> : +	bool "Wireless extensions sysfs files"
> : +	default y
> : +	depends on WIRELESS_EXT && SYSFS
> : +	help
> : +	  This option enables the deprecated wireless statistics
> : +	  files in /sys/class/net/*/wireless/. The same information
> : +	  is available via the ioctls as well.
> : +
> : +	  Say Y if you have programs using it (we don't know of any).
> : 
> 
> So if you've enabled CONFIG_WIRELESS_EXT_SYSFS (and it correctly has
> default y) then things should continue to work OK.  And the deprecation
> date of 2010 sounds reasonable.  In fact generous, for us...
> 
> So where's the problem?

The Kconfig message implies that nobody uses the files. It needs to be 
updated to state that older versions of HAL do use them (and ideally 
what version this was changed).
