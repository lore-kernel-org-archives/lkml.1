Return-Path: <linux-kernel-owner+w=401wt.eu-S1757082AbYEOKHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082AbYEOKHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 06:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751699AbYEOKHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 06:07:20 -0400
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:12650 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751063AbYEOKHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 06:07:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuIIAF+oK0iWZR7iWmdsb2JhbACSDAEdmzk
X-IronPort-AV: E=Sophos;i="4.27,491,1204464600"; 
   d="scan'208";a="112880545"
Message-ID: <8ECDBB4EB5394859BFFACAAEE3A6EDB0@uglypunk>
From: "Kingsley Foreman" <kingsley@internode.com.au>
To: "Jarek Poplawski" <jarkao2@gmail.com>
Cc: "Eric Dumazet" <dada1@cosmosbay.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20080515091216.GA6550@ff.dom.local>
Subject: Re: NET_SCHED cbq dropping too many packets on a bonding interface
Date: Thu, 15 May 2008 19:36:54 +0930
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 12.0.1606
X-MimeOLE: Produced By Microsoft MimeOLE V12.0.1606
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i just rolled back the kernel to 2.6.24 and im seeing the same thing,

I was using 2.6.22 before and didn't see the problem, txqueuelen on the 
bond0 interface is 0 (the default)

--------------------------------------------------
From: "Jarek Poplawski" <jarkao2@gmail.com>
Sent: Thursday, May 15, 2008 6:42 PM
To: "Kingsley Foreman" <kingsley@internode.com.au>
Cc: "Eric Dumazet" <dada1@cosmosbay.com>; "Andrew Morton" 
<akpm@linux-foundation.org>; <linux-kernel@vger.kernel.org>; 
<netdev@vger.kernel.org>
Subject: Re: NET_SCHED cbq dropping too many packets on a bonding interface

> On 15-05-2008 08:16, Kingsley Foreman wrote:
> ...
>>>>> Ive been using qdisc for quite a while without any problems,
>>>>> I just rebuilt a gentoo box with 2.6.25 kernel that does a lot of
>>>>> traffic
>>>>> ~1000mbits+ over a bonded interface
>>>>>
>>>>> Im however seeing a big problem with cbq class dropping packets for no
>>>>> reason i can see, and it is causing a lot of speed issues.
> ...
>
> Do you mean the same box with the same config but the previous kernel
> (2.6.24) doesn't show this problem? BTW, what is txqueuelen on this
> bond0?
>
> Regards,
> Jarek P.
> 
