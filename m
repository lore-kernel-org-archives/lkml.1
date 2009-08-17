Return-Path: <linux-kernel-owner+w=401wt.eu-S1758209AbZHQWdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209AbZHQWdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 18:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbZHQWdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 18:33:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59713
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751176AbZHQWdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 18:33:15 -0400
Date: Mon, 17 Aug 2009 15:33:26 -0700 (PDT)
Message-Id: <20090817.153326.69833512.davem@davemloft.net>
To: mingo@elte.hu
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, akpm@linux-foundation.org,
       nhorman@tuxdriver.com, rostedt@goodmis.org
Subject: Re: [PATCH -next] trace_skb: fix build when CONFIG_NET is not
 enabled
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090817215808.GB15016@elte.hu>
References: <4A89BF90.5070202@oracle.com>
	<20090817215808.GB15016@elte.hu>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 17 Aug 2009 23:58:08 +0200

>> --- linux-next-20090817.orig/kernel/trace/Kconfig
>> +++ linux-next-20090817/kernel/trace/Kconfig
>> @@ -236,6 +236,7 @@ config BOOT_TRACER
>>  
>>  config SKB_SOURCES_TRACER
>>  	bool "Trace skb source information"
>> +	depends on NET
>>  	select GENERIC_TRACER
>>  	help
>>  	   This tracer helps developers/sysadmins correlate skb allocation and
> 
> Hm, there's nothing like this in the tracing tree.
> 
> Could we please move kernel/trace/* commits to the tracing tree, so 
> that it gets adequate testing and review, etc?

This one (like previous networking tracing changes Neil has
made) touched a decent amount of networking code, and thus
we integrated it into net-next-2.6
