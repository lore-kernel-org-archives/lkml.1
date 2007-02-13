Return-Path: <linux-kernel-owner+w=401wt.eu-S1750943AbXBMUQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750943AbXBMUQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 15:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750948AbXBMUQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 15:16:25 -0500
Received: from hax.kala.ee ([194.126.124.39]:21664 "HELO hax.kala.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750943AbXBMUQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 15:16:24 -0500
From: Hasso Tepper <hasso@estpak.ee>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: /proc/sys/net/ipv[46]/conf/ issue unsolved
Date: Tue, 13 Feb 2007 22:16:13 +0200
User-Agent: KMail/1.9.5
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200702131529.04708.hasso@estpak.ee> <20070213090224.2826859f@localhost.localdomain>
In-Reply-To: <20070213090224.2826859f@localhost.localdomain>
Organization: Elion Enterprises Ltd.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702132216.13828.hasso@estpak.ee>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> > You can disable it in /proc/sys/net/ipv6/conf/default/... and then
> > reenable it on the interfaces that you actually want.

And YOSHIFUJI Hideaki answered to this:

> The point is:
> 
>  - Until we have live address(es), we do not create inet6_dev{} for that
>    device.
>  - We do NOT run DAD until the link is ready (netif_carrier_ok()).
> 
> This means, we do NOT have any addresses until the link is once up,
> and thus, because the sysctl entries live in inet6_dev{}, we do not
> install net.ipv6.conf.ethX from values of net.ipv6.conf.default until
> then.

Ie. to make it very clear - I can't reenable it on the interface before
the first "carrier up" event (cable is plugged on). That's the point -
AFAICS the only way I can configure interface differently than default is
via daemon listening interface events via netlink. I can't do it in any
way before.


regards,

-- 
Hasso Tepper
Elion Enterprises Ltd. [AS3249]
IP & Data Networking Expert
