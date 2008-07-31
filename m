Return-Path: <linux-kernel-owner+w=401wt.eu-S1756275AbYGaR5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbYGaR5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 13:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbYGaR5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 13:57:13 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:53360 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbYGaR5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 13:57:12 -0400
X-BigFish: VPS-20(z34a4lz1432R98dR1805Mzz10d3izzz2fh6bh64h)
X-Spam-TCS-SCL: 3:0
Message-ID: <4891FD95.7090700@am.sony.com>
Date: Thu, 31 Jul 2008 10:59:49 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: dwmw2@infradead.org, torvalds@linux-foundation.org,
       thomas.petazzoni@free-electrons.com, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, michael@free-electrons.com
Subject: Re: [patch 0/4] [resend] Add configuration options to disable features
 not needed on embedded devices
References: <1217498355.3454.103.camel@pmac.infradead.org>	<20080731.030205.153067850.davem@davemloft.net>	<1217499316.3454.118.camel@pmac.infradead.org> <20080731.032553.67275433.davem@davemloft.net>
In-Reply-To: <20080731.032553.67275433.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Jul 2008 17:56:56.0262 (UTC) FILETIME=[D254DE60:01C8F336]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> Some folks might find it instructive to do a google code search
> or similar on the multicast socket options this things dikes out
> of the tree.
> 
> Even simple things like NTP will spew failures with this CONFIG_IGMP
> thing turned off.  And that's just the tip of the iceberg.

I don't know of any embedded products that ship with NTP turned
on.  It's best to assume, with embedded, that we're not shipping
ANY of the desktop or server applications you are familiar with.
Absent those, does something break in the kernel with multicast
support when IGMP is turned off?
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

