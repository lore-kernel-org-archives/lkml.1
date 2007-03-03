Return-Path: <linux-kernel-owner+w=401wt.eu-S2992874AbXCCBZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992874AbXCCBZN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 20:25:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992877AbXCCBZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 20:25:12 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:55642 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992871AbXCCBZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 20:25:06 -0500
Message-ID: <45E8CE6D.6000801@garzik.org>
Date: Fri, 02 Mar 2007 20:25:01 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: akpm@linux-foundation.org, netdev <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH] schedule wext/rtnl for removal
References: <20070301153105.GC5806@tuxdriver.com>
In-Reply-To: <20070301153105.GC5806@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John W. Linville wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> 
> Since wext is being replaced as fast as we can (it'll probably stick
> around for legacy drivers though) and the wext/netlink stuff was never
> really used, this schedules it for removal.
> 
> The removal schedule is tight but there are no users of the code, the
> main user of the wext user interface are the wireless-tools, they only
> have an alpha version using the netlink interface and even that is
> incomplete.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> Which you consider applying this feature-removal-schedule.txt patch
> in the current (i.e. pre-2.6.21) timeframe?
> 
>  Documentation/feature-removal-schedule.txt |   12 ++++++++++++
>  1 file changed, 12 insertions(+)

When you send this sort of stuff, spam as many lists as reasonable.

The removal of a recently-added userspace ABI is an unusual event, and 
IMO needs discussing.

