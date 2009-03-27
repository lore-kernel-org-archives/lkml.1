Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbZC0J31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbZC0J31 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 05:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755861AbZC0J3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 05:29:17 -0400
Received: from stinky.trash.net ([213.144.137.162]:55459 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbZC0J3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 05:29:16 -0400
Message-ID: <49CC9C62.7080701@trash.net>
Date: Fri, 27 Mar 2009 10:29:06 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Pablo Neira Ayuso <pablo@netfilter.org>
CC: Steven Noonan <steven@uplinklabs.net>, linux-kernel@vger.kernel.org,
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] iptables: "cluster" match uses IPv6-specific code without
 ifdef
References: <1238100203-23454-1-git-send-email-steven@uplinklabs.net> <49CC9A32.3060303@netfilter.org>
In-Reply-To: <49CC9A32.3060303@netfilter.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pablo Neira Ayuso wrote:
> Steven Noonan wrote:
>> The symbol __ipv6_addr_type is only available with CONFIG_IPV6 or
>> CONFIG_IPV6_MODULE.
> 
> Please, CC netfilter-devel for netfilter-related issues. Patrick, I'm
> fine with this, can you apply this patch?

Is my reading correct that this won't introduce a module
dependency on IPv6?

