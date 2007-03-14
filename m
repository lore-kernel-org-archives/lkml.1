Return-Path: <linux-kernel-owner+w=401wt.eu-S1161071AbXCNUmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161071AbXCNUmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 16:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161195AbXCNUmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 16:42:52 -0400
Received: from stinky.trash.net ([213.144.137.162]:46713 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161071AbXCNUmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 16:42:50 -0400
Message-ID: <45F85E40.6050409@trash.net>
Date: Wed, 14 Mar 2007 21:42:40 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051017)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: Arkadiusz Miskiewicz <arekm@maven.pl>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, lartc@mailman.ds9a.nl
Subject: Re: [ANNOUNCE] iproute2 2.6.20-070313
References: <20070313151549.332004c9@freekitty>	<200703141223.48927.arekm@maven.pl>	<45F7E527.6030307@trash.net>	<200703141316.05509.arekm@maven.pl>	<45F7EB5C.5010901@trash.net> <20070314101443.4347efdd@freekitty>
In-Reply-To: <20070314101443.4347efdd@freekitty>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> On Wed, 14 Mar 2007 13:32:28 +0100
> Patrick McHardy <kaber@trash.net> wrote:
> 
>>RTA_* attributes aren't used for routing rules anymore inside
>>the kernel.
> 
> 
> But we need to keep them in iproute2 for back compatibility?

Not really for compatibility, its the numerical values that matter.
iproute hasn't been changed to use the FRA_* attributes for routing
rules, but it might be a good idea to do this before adding the next
RTA_* attribute since RTA_FWMASK doesn't have any meaning for routes
in the kernel, so the next RTA attribute we add could just use the
same value instead of leaving a hole.

