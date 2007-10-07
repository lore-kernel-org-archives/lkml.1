Return-Path: <linux-kernel-owner+w=401wt.eu-S1753307AbXJGNrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbXJGNrr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 09:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbXJGNrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 09:47:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:62723 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbXJGNrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 09:47:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=NACy+U41blz2jmyMHpzAziwaY1Yhh85N1J1TtbtDGVFiF3nGF3EsqAnRHoGqQvwYr0O1eOvPvidmZrt11gxSuYqX+hx84L4ONqWATQRzDvqai82CO4kYbPgW+plEcNCLQQVnB6Qs0ziVGkbNJvkwexLngcDS4BVJeHurVEgcOoM=
Message-ID: <4708E3CF.4000401@gmail.com>
Date: Sun, 07 Oct 2007 17:49:03 +0400
From: "Denis V. Lunev" <dlunev@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: netdev <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, den@openvz.org,
       David Miller <davem@davemloft.net>
Subject: Re: [NET] IPv6 oops bisected
References: <4708D677.1030601@garzik.org> <4708E016.9020300@garzik.org>
In-Reply-To: <4708E016.9020300@garzik.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Jeff Garzik wrote:
>> The commit
>>
>> commit 5f5dace1ce001b24fb8286e09ffd3c4d2b547e09
>> Author: Denis V. Lunev <den@openvz.org>
>> Date:   Thu Sep 27 12:41:26 2007 -0700
>>
>>     [NET]: Various dst_ifdown routines to catch refcounting bugs
>>
>> causes a 100% reproducible oops in net-2.6.24.git, in ip6_route_add().
>>
>> Platform: x86-64 Fedora 7
>>
>> Config and lspci attached.
> 
> And indeed, reverting this commit with 'patch -R' makes things work again.
> 
>     Jeff

Can you me command to execute to reproduce the problem? and oops if
possible.

Regards,
	Den
