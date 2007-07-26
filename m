Return-Path: <linux-kernel-owner+w=401wt.eu-S936350AbXGZSmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936350AbXGZSmn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 14:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935741AbXGZSmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 14:42:08 -0400
Received: from poy.chewa.net ([194.242.114.73]:3976 "EHLO poy.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935174AbXGZSmH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 14:42:07 -0400
X-Greylist: delayed 2111 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jul 2007 14:42:06 EDT
From: =?utf-8?q?R=C3=A9mi_Denis-Courmont?= <rdenis@simphalempin.com>
Organization: Remlab.net
To: Simon Arlott <simon@fire.lp0.eu>
Subject: Re: [PATCH] IPv6: ipv6_addr_type() doesn't know about RFC4193 addresses
Date: Thu, 26 Jul 2007 21:06:48 +0300
User-Agent: KMail/1.9.6
Cc: Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com>,
       netdev@vger.kernel.org, davem@davemloft.net,
       linux-kernel@vger.kernel.org, lksctp-developers@lists.sourceforge.net,
       Srinivas Akkipeddi <sakkiped@starentnetworks.com>
References: <18087.57717.495366.413571@zeus.sw.starentnetworks.com> <46A8D837.1030400@simon.arlott.org.uk>
In-Reply-To: <46A8D837.1030400@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707262106.49131.rdenis@simphalempin.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 July 2007 20:21:59 Simon Arlott wrote:
> On 26/07/07 00:49, Dave Johnson wrote:
> > ipv6_addr_type() doesn't check for 'Unique Local IPv6 Unicast
> > Addresses' (RFC4193) and returns IPV6_ADDR_RESERVED for that range.
> >
> > +	if ((st & htonl(0xFE000000)) == htonl(0xFC000000))
> > +		return (IPV6_ADDR_UNICAST |
> > +			IPV6_ADDR_SCOPE_TYPE(IPV6_ADDR_SCOPE_GLOBAL));			/* RFC 4193 */
>
> But ULA's scope isn't global, shouldn't it be IPV6_ADDR_SCOPE_ORGLOCAL ?

Yes it is - global.

-- 
Rémi Denis-Courmont
