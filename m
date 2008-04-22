Return-Path: <linux-kernel-owner+w=401wt.eu-S932841AbYDVU4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841AbYDVU4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 16:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762871AbYDVU4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 16:56:09 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:41434
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762800AbYDVU4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 16:56:08 -0400
X-Greylist: delayed 594 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Apr 2008 16:56:07 EDT
Message-ID: <480E5CB3.2080003@microgate.com>
Date: Tue, 22 Apr 2008 15:46:27 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: James Chapman <jchapman@katalix.com>, David Miller <davem@davemloft.net>,
       alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org, jeff@garzik.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] Re: WAN: new PPP code for generic HDLC
References: <20080412115950.1cbb9cfa@core>	<m33apqomgf.fsf@maximus.localdomain>	<m33apjp32f.fsf@maximus.localdomain>	<20080418.153256.253949503.davem@davemloft.net>	<m3ve2b9qe8.fsf@maximus.localdomain> <480CEB7D.8070702@katalix.com> <m33apdyajf.fsf@maximus.localdomain>
In-Reply-To: <m33apdyajf.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> It's complex, I think kernel interface to generic HDLC would mean more
> code than PPP implementation required for fixed lines.
> Additional requirement - userspace daemon with additional plugin - may
> not be the best thing for fixed lines either.
> 
> That would break backward compatibility, too.

I maintain both pppd and generic HDLC PPP
interfaces for the synclink drivers.
I would like to have a single PPP implementation,
but what Krzysztof writes about compatibility and complexity
(both in coding and user configuration) is a real issue.

Many customers who choose to use generic HDLC PPP are *dead*
set against the added complexity and (user space)
components of using pppd even though it has more features.
I say that having tried to persuade such users to use pppd.
The response is usually "support the simpler generic
HDLC PPP way of doing things or we will go elsewhere".
Others require the extra features of pppd.

I understand customer desires are not always rational
or a primary concern when making these architectural
decisions, but I know forcing the extra complexity and
components of pppd on generic HDLC users will cause a
lot of anger and defections.

-- 
Paul Fulghum
Microgate Systems, Ltd.
