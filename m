Return-Path: <linux-kernel-owner+w=401wt.eu-S1753787AbZFFIo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbZFFIo0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 04:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbZFFIoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 04:44:13 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60678 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbZFFIoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 04:44:12 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A2A2C26.1070106@s5r6.in-berlin.de>
Date: Sat, 06 Jun 2009 10:43:18 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090411 SeaMonkey/1.1.16
MIME-Version: 1.0
To: David VomLehn <dvomlehn@cisco.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-usb@vger.kernel.org, greg@kroah.com, linux-scsi@vger.kernel.org,
       netdev@vger.kernel.org, arjan@infradead.org
Subject: Re: [PATCH 1/7] initdev:kernel:Asynchronously-discovered device	synchronization,
 v6
References: <20090606023403.GA5645@cuplxvomd02.corp.sa.net>
In-Reply-To: <20090606023403.GA5645@cuplxvomd02.corp.sa.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David VomLehn wrote:
> +Some rules about correct usage:
> +o	Each call to initdev_found *must* be matched by a call to
> +	initdev_probe_done.

This would be useful as inline kerneldoc documentation at initdev_found().

> +o	The value of initdev_mask passed to initdev_found and
> +	initdev_probe_done for a given device must be identical.

And this as kerneldoc at initdev_probe_done().

What happens if the calls or the call arguments aren't balanced, e.g. 
due to a mistake in an error path?  The kernel will hang?

(BTW, much, though possibly not all, of the "History" section of your 
changelog should be below the --- delimiter, and the "v6" in the subject 
should be within the [PATCH ...] prefix.)
-- 
Stefan Richter
-=====-==--= -==- --==-
http://arcgraph.de/sr/
