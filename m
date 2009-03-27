Return-Path: <linux-kernel-owner+w=401wt.eu-S1757573AbZC0MsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573AbZC0MsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 08:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755927AbZC0MsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 08:48:11 -0400
Received: from mail.us.es ([193.147.175.20]:42008 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756148AbZC0MsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 08:48:10 -0400
Message-ID: <49CCCAF1.7060405@netfilter.org>
Date: Fri, 27 Mar 2009 13:47:45 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
User-Agent: Thunderbird 1.5.0.5 (X11/20060812)
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: Steven Noonan <steven@uplinklabs.net>, linux-kernel@vger.kernel.org,
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] iptables: "cluster" match uses IPv6-specific code without
 ifdef
References: <1238100203-23454-1-git-send-email-steven@uplinklabs.net> <49CC9A32.3060303@netfilter.org> <49CC9C62.7080701@trash.net>
In-Reply-To: <49CC9C62.7080701@trash.net>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> Steven Noonan wrote:
>>> The symbol __ipv6_addr_type is only available with CONFIG_IPV6 or
>>> CONFIG_IPV6_MODULE.
>>
>> Please, CC netfilter-devel for netfilter-related issues. Patrick, I'm
>> fine with this, can you apply this patch?
> 
> Is my reading correct that this won't introduce a module
> dependency on IPv6?

Hm, this fixes a compilation issue when IPv6 is not enabled. In that
case you can still use the cluster match, so I don't see any extra
modules dependencies.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
