Return-Path: <linux-kernel-owner+w=401wt.eu-S1765746AbXF2MNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765746AbXF2MNj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 08:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761094AbXF2MNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 08:13:30 -0400
Received: from stinky.trash.net ([213.144.137.162]:43298 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761205AbXF2MN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 08:13:29 -0400
Message-ID: <4684F75E.90304@trash.net>
Date: Fri, 29 Jun 2007 14:13:18 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andreas Steinmetz <ast@domdv.de>
CC: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       netfilter-devel@lists.netfilter.org
Subject: Re: mss to pmtu clamping partially broken?
References: <4684E853.20900@domdv.de> <4684EF6A.7070109@trash.net> <4684F3D8.1080800@domdv.de> <4684F4FB.9070807@trash.net> <4684F5D3.8020506@domdv.de>
In-Reply-To: <4684F5D3.8020506@domdv.de>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Steinmetz wrote:
> Patrick McHardy wrote:
> 
>>- assuming you have ethernet internally, the PMTU from your router
>>to the internal hosts is 1500, so it won't do any clamping.
>>
> 
> 
> Yep, internal PMTU is 1500, still the incoming packets are clamped to
> 1452 on the one line and not clamped on the other.
> 
> 
>>Does that explain it?
>>
>>A useful thing for TCPMSS for routers would be to clamp to the
>>minimum of the PMTU of both directions. But thats not supported
>>so far.
>>
> 
> 
> I wonder, as somteimes it gets clamped. If it would never have been
> clamped I wouldn't have asked.


Its possible that one of your ISPs is doing clamping. You could
check on ppp0 if thats the case. Or maybe for some reason the
PMTU value for the internal host is smaller than 1500. You can
check that by doing "ip route get <internal host>".


