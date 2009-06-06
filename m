Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbZFFJJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbZFFJJZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 05:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbZFFJJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 05:09:13 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60791 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbZFFJJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 05:09:11 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A2A320F.5020008@s5r6.in-berlin.de>
Date: Sat, 06 Jun 2009 11:08:31 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090411 SeaMonkey/1.1.16
MIME-Version: 1.0
To: David VomLehn <dvomlehn@cisco.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-usb@vger.kernel.org, greg@kroah.com, linux-scsi@vger.kernel.org,
       netdev@vger.kernel.org, arjan@infradead.org
Subject: Re: [PATCH 1/7] initdev:kernel:Asynchronously-discovered device	synchronization,
 v6
References: <20090606023403.GA5645@cuplxvomd02.corp.sa.net> <4A2A2C26.1070106@s5r6.in-berlin.de>
In-Reply-To: <4A2A2C26.1070106@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> What happens if the calls or the call arguments aren't balanced, e.g. 
> due to a mistake in an error path?  The kernel will hang?

Yes, unless the waiting subsystems implement timeouts.
-- 
Stefan Richter
-=====-==--= -==- --==-
http://arcgraph.de/sr/
