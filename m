Return-Path: <linux-kernel-owner+w=401wt.eu-S1753224AbZIBRvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbZIBRvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 13:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbZIBRvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 13:51:49 -0400
Received: from stinky.trash.net ([213.144.137.162]:51565 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbZIBRvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 13:51:48 -0400
Message-ID: <4A9EB0AE.4080904@trash.net>
Date: Wed, 02 Sep 2009 19:51:42 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: Hannes Eder <heder@google.com>, lvs-devel@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org,
       =?ISO-8859-15?Q?Fabien_Duch=EAne?= <mad_fab@skynet.be>,
       Jean-Luc Fortemaison <jl.fortemaison@uclouvain.be>,
       Julian Anastasov <ja@ssi.bg>, Julius Volz <julius.volz@gmail.com>,
       Laurent Grawet <laurent.grawet@uclouvain.be>,
       Simon Horman <horms@verge.net.au>, Wensong Zhang <wensong@linux-vs.org>
Subject: Re: [PATCH 1/3] netfilter: xt_ipvs (netfilter matcher for IPVS)
References: <20090902101417.11561.45663.stgit@jazzy.zrh.corp.google.com>  <20090902101527.11561.59498.stgit@jazzy.zrh.corp.google.com>  <4A9E8711.1070807@trash.net> <b5ddba180909020833w1739bd54t11fded8150007abc@mail.gmail.com> <4A9E90E4.9080805@trash.net> <alpine.LSU.2.00.0909021748310.25091@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LSU.2.00.0909021748310.25091@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Wednesday 2009-09-02 17:36, Patrick McHardy wrote:
>>> Nice, I'll use par->family.
>>>
>>> So in theory I do not even need a check like the following in the beginning?
>>>
>>> 	if (family != NFPROTO_IPV4
>>> #ifdef CONFIG_IP_VS_IPV6
>>> 	    && family != NFPROTO_IPV6
>>> #endif
>>> 		) {
>>> 		match = false;
>>> 		goto out;
>>> 	}
>> With the AF_UNSPEC registration of your match, it might be used
> 
> par->family always contains the NFPROTO of the invoking implementation,
> which can never be UNSPEC (except, in future, xtables2 ;-)

I didn't say it will be UNSPEC, I said it might be something
different than IPV4/IPV6 unless that is checked *somewhere*.
