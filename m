Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbZJJDnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbZJJDnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 23:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbZJJDnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 23:43:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60212
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753710AbZJJDnR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 23:43:17 -0400
Date: Fri, 09 Oct 2009 20:43:12 -0700 (PDT)
Message-Id: <20091009.204312.130400631.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: thomas@wytron.com.tw, netdev@vger.kernel.org,
       thierry.reding@avionic-design.de, nios2-dev@sopc.et.ntust.edu.tw,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Add netdev_alloc_skb_ip_align() helper
From: David Miller <davem@davemloft.net>
In-Reply-To: <4ACF6562.9040109@gmail.com>
References: <4ACD585B.5080106@gmail.com>
	<20091007.224036.247820677.davem@davemloft.net>
	<4ACF6562.9040109@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 9 Oct 2009 18:31:30 +0200

> David Miller a écrit :
> 
>> Looks ok, but I want to look at how often this exact sequence
>> would match.  If it applies to a lot of cases, I'll add this
>> but I know of many exceptions in my head already :-)
> 
> Well, it was more as a reference. I believe about 20-30 call sites
> could use it. Do you want me to provide a combo patch ?

No, that's not necessary.
