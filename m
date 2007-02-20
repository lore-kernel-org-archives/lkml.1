Return-Path: <linux-kernel-owner+w=401wt.eu-S965192AbXBTP4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965192AbXBTP4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 10:56:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965189AbXBTP4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 10:56:40 -0500
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:7269 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965186AbXBTP4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 10:56:39 -0500
In-Reply-To: <200702201629.40758.m.kozlowski@tuxland.pl>
References: <Pine.LNX.4.64.0701300543420.17991@CPE00045a9c397f-CM001225dbafb6> <200702201629.40758.m.kozlowski@tuxland.pl>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <014B4DC2-53BB-423E-B261-569299CAB2D9@kernel.crashing.org>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Paul Mackerras <paulus@samba.org>,
       dhowells@redhat.com
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH] Add "is_power_of_2" checking to log2.h.
Date: Tue, 20 Feb 2007 09:56:36 -0600
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
X-Mailer: Apple Mail (2.752.2)
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 20, 2007, at 9:29 AM, Mariusz Kozlowski wrote:

> Hello,
>
> Please fix the parentheses thing in both arch/powerpc/mm/ 
> pgtable_32.c and
> arch/ppc/mm/pgtable.c.
>
>> +#define is_power_of_4(x)	is_power_of_2(x) && (ffs(x) & 1))

These should be fixed and pushed upstream by now.

- k
