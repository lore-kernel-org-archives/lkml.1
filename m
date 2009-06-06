Return-Path: <linux-kernel-owner+w=401wt.eu-S1754928AbZFFI4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbZFFI4A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 04:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419AbZFFIzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 04:55:48 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60701 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbZFFIzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 04:55:45 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A2A2EED.3060506@s5r6.in-berlin.de>
Date: Sat, 06 Jun 2009 10:55:09 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090411 SeaMonkey/1.1.16
MIME-Version: 1.0
To: David VomLehn <dvomlehn@cisco.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-usb@vger.kernel.org, greg@kroah.com, linux-scsi@vger.kernel.org,
       netdev@vger.kernel.org, arjan@infradead.org
Subject: Re: [PATCH 3/7] initdev:kernel:Await console discovery, v6
References: <20090606023407.GA5695@cuplxvomd02.corp.sa.net>
In-Reply-To: <20090606023407.GA5695@cuplxvomd02.corp.sa.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David VomLehn wrote:
> Wait for the console device to become available.
> 
> History
> v6	Changed BOOTDEV_* to INITDEV_*.
> v5.1	Corrected call to initdev_register() to be initdev_registered().
> v5	Change bootdev_* to initdev_*.
> v4	Use new hotplug synchronization infrastructure. Include Braille
> 	console support.
> v3.2	Use only a single new command line parameter by adding the possible
> 	value "forever".  Add message specifying the parameter to modify to
> 	increase the delay for console initialization
> v3.1	Correct the abbreviation for milliseconds in
> 	Documentation/kernel-parameters.txt to be "ms", not "mS". Thanks to
> 	Peter Anvin for this.
> v3	Increase the default delay to 1 second and add kernel command line
> 	parameters to override the default delay. Thanks to David Brownell for
> 	his helpful suggestions.
> v2	Wait for the preferred console rather than any console. Make the
> 	delay interval a tunable.
> v1	Initial version
> 
> Signed-off-by: David VomLehn <dvomlehn@cisco.com>
> ---
>  drivers/accessibility/braille/braille_console.c |    2 +
>  kernel/printk.c                                 |   29 ++++++++++++++++++++++-
>  2 files changed, 30 insertions(+), 1 deletions(-)

Is this diff complete?
-- 
Stefan Richter
-=====-==--= -==- --==-
http://arcgraph.de/sr/
