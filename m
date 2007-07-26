Return-Path: <linux-kernel-owner+w=401wt.eu-S1764131AbXGZRWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764131AbXGZRWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 13:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760858AbXGZRWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 13:22:08 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:37874 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760575AbXGZRWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 13:22:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:OpenPGP:Content-Type:Content-Transfer-Encoding;
	b=QY6FijXIlV6PSC+KSrZa0Gi+nOmgZvgQPB35G2ZJi59+bjhV2n5psY0FtljLbCRq2sonzVT606KShZVQcBtwaq/HSm4/ZgixZPrOTy0+k3pVNpOo2yFzPW33DHzmT/E9;
Message-ID: <46A8D837.1030400@simon.arlott.org.uk>
Date: Thu, 26 Jul 2007 18:21:59 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com>
CC: netdev@vger.kernel.org, davem@davemloft.net, linux-kernel@vger.kernel.org,
       lksctp-developers@lists.sourceforge.net,
       Srinivas Akkipeddi <sakkiped@starentnetworks.com>
Subject: Re: [PATCH] IPv6: ipv6_addr_type() doesn't know about RFC4193 addresses
References: <18087.57717.495366.413571@zeus.sw.starentnetworks.com>
In-Reply-To: <18087.57717.495366.413571@zeus.sw.starentnetworks.com>
X-Enigmail-Version: 0.95.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/07/07 00:49, Dave Johnson wrote:
> ipv6_addr_type() doesn't check for 'Unique Local IPv6 Unicast
> Addresses' (RFC4193) and returns IPV6_ADDR_RESERVED for that range.

> +	if ((st & htonl(0xFE000000)) == htonl(0xFC000000))
> +		return (IPV6_ADDR_UNICAST |
> +			IPV6_ADDR_SCOPE_TYPE(IPV6_ADDR_SCOPE_GLOBAL));			/* RFC 4193 */

But ULA's scope isn't global, shouldn't it be IPV6_ADDR_SCOPE_ORGLOCAL ?

-- 
Simon Arlott
