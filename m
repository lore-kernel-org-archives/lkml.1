Return-Path: <linux-kernel-owner+w=401wt.eu-S1030829AbXCNJs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030829AbXCNJs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030835AbXCNJs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:48:27 -0400
Received: from ag-out-0708.google.com ([72.14.246.245]:30675 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030829AbXCNJs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:48:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=M91wteKKOlNlTj3EuJo09KlLQMWZjX4beQJTmUxa8T9KamjO0Sr/USBqVm4L+qVTKb2PHhm4aBxHUajwzREM4vVAuq4Vu1sdxkhFzHUoDkZBz3Vlc1dEy4cveE08H1PePB9oyrPhI0caKwmyJA0Uy5YxlPxOtr7M7HbTbUoFq30=
Message-ID: <77e1146f0703140248ua2e3a4dn660de5f2b5f500d1@mail.gmail.com>
Date: Wed, 14 Mar 2007 15:18:26 +0530
From: "sujay g" <mail.sujayg@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 - Take 2
In-Reply-To: <p73slc8863r.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070314050819.536207642@goodmis.org>
	 <p73slc8863r.fsf@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am newbie developing a routing application which
needs three features;

1. if the fib lookup fails, my application needs to know about using
preferably
netlink, -- any direction to some sample code or files in the kernel???

2. I need a counter recording the hits a fib entry is chosen for
packet forwarding. Is it the function fn_trie_lookup in file
/net/ipv4/fib_trie.c i need to modify and look into?
-- ?? and therefore is it safe to add a int counter in fib_node w/o
breaking the build??

2. need to read the entire fib, i.e dump the fib to the user space,
-- again any direction to some sample code etc..
i have seen a fn in /source/net/ipv4/fib_frontend.c , which looks like
is supposed to dump the routes but not sure how to use it..

line no.581 int inet_dump_fib(struct sk_buff *skb, struct
netlink_callback *cb)
Also;
fn_trie_dump() in /net/ipv4/fib_trie.c


This could be an inappropriate list for the above questions,  if it is
request for
some direction on the appropriate mailing list

Appreciate any help.

Thanking you,
Sujay
