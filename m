Return-Path: <linux-kernel-owner+w=401wt.eu-S1759293AbXLQFDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759293AbXLQFDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 00:03:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750857AbXLQFDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 00:03:15 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:41111 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbXLQFDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 00:03:14 -0500
Date: Mon, 17 Dec 2007 10:21:26 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Amogh Hooshdar <amoghhooshdar@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 1.0.0.0 DNS replies for many domain names (network)
Message-ID: <20071217045126.GB17715@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: Amogh Hooshdar <amoghhooshdar@gmail.com>,
	linux-kernel@vger.kernel.org
References: <78c462ad0712140350v62ae169fm7a2ce077325ace5f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <78c462ad0712140350v62ae169fm7a2ce077325ace5f@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Amogh Hooshdar <amoghhooshdar@gmail.com> [2007-12-14 17:20:17]:

> I am having a strange problem with Debian Etch 4.0 (both 64-bit and
> 32-bit) using 2.6.18 kernel. Most websites do not open with browser,
> Pidgin and most other GUI applicatoins. but I am able to ping them
> fine. I am also able to do nslookup properly. When I tried to
> investigate it with Wireshark net sniffer, I observed the following.
> 
> PROBLEM WITH 2.6.18
> Say, I try to open www.google.com, browser sends DNS query for
> www.google.com to my DNS server which is correctly configured in
> resolv.conf. It replies with the correct IP address. www.google.com
> redirects the browser to www.google.co.in. browser sends a DNS query
> again for www.google.co.in and the DNS server replies with 1.0.0.0
> which obviously is the wrong address.

I had this problem on Debian 4.0 and it was due to bug in the DSL
router.  I had DNS server set to 192.168.1.1 that is my DSL router
that holds the real DNS IP and forwards the DNS lookup request.

Once in a while the DNS proxy server will give out 1.0.0.0.  The
solution I used was to find the real DNS server and fill it in
resolv.conf  This avoids the DNS proxy on the router and then problem
went away.

https://bugs.launchpad.net/ubuntu/+bug/81057

--Vaidy
 
