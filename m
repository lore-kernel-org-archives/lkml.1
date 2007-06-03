Return-Path: <linux-kernel-owner+w=401wt.eu-S1757391AbXFCRtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbXFCRtM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 13:49:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755299AbXFCRs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 13:48:59 -0400
Received: from www.aws-it.at ([83.218.181.38]:29883 "EHLO bigboss.aws-it.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202AbXFCRs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 13:48:58 -0400
Message-ID: <20070603194856.9eyyeukhesgw0owg@bigboss.aws-it.at>
Date: Sun, 03 Jun 2007 19:48:56 +0200
From: Strobl Anton <a.strobl@aws-it.at>
To: Patrick McHardy <kaber@trash.net>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, Netdev <netdev@vger.kernel.org>
Subject: Re: OOPS iproute2/tc/u32_destroy in 2.6.22-rc3-git6
References: <20070603161814.q5x2jsq8dck4gcgw@bigboss.aws-it.at>
	<4662D881.5080600@googlemail.com> <4662EE12.1080400@trash.net>
In-Reply-To: <4662EE12.1080400@trash.net>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-15;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.1.4)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patch for sch_cbq.c works perfect - no more kernel panic!
(sch_atm.c => im not able to test atm shaping, sorry)

Thank you for the fast response to my request!

Strobl Anton

<a dot strobl at aws-it dot at>


Zitat von Patrick McHardy <kaber@trash.net>:

> Michal Piotrowski wrote:
>> Strobl Anton pisze:
>>
>>> While trying to stop qdisc/cbq with command
>>>
>>>    tc qdisc del dev eth1 root
>>>
>>> EIP is at u32_destroy+0x52/0xd8 [cls_u32]
>
>
> Please try this patch.
>
>



