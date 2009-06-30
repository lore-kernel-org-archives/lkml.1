Return-Path: <linux-kernel-owner+w=401wt.eu-S1760302AbZF3CQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760302AbZF3CQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 22:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755608AbZF3CQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 22:16:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36821
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754554AbZF3CQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 22:16:50 -0400
Date: Mon, 29 Jun 2009 19:16:55 -0700 (PDT)
Message-Id: <20090629.191655.193712233.davem@davemloft.net>
To: rientjes@google.com
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, thomas@m3y3r.de, rjw@sisk.pl,
       dccp@vger.kernel.org
Subject: Re: [Bug #13666] WARNING: at mm/page_alloc.c:1743
 __alloc_pages_nodemask
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.00.0906291703430.17663@chino.kir.corp.google.com>
References: <ij4ZQY4URcP.A.F3B.vIASKB@chimera>
	<6JJ2m5kyucK.A.cBC.0IASKB@chimera>
	<alpine.DEB.2.00.0906291703430.17663@chino.kir.corp.google.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Rientjes <rientjes@google.com>
Date: Mon, 29 Jun 2009 17:06:42 -0700 (PDT)

> On Mon, 29 Jun 2009, Rafael J. Wysocki wrote:
> 
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>> 
>> The following bug entry is on the current list of known regressions
>> from 2.6.30.  Please verify if it still should be listed and let me know
>> (either way).
>> 
>> 
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13666
>> Subject		: WARNING: at mm/page_alloc.c:1743 __alloc_pages_nodemask
>> Submitter	: Thomas Meyer <thomas@m3y3r.de>
>> Date		: 2009-06-27 16:15 (2 days old)
>> References	: http://lkml.org/lkml/2009/6/27/75
>> 
> 
> dccp_init() is trying to allocate a goal that causes the order in 
> __get_free_pages() to be >= MAX_ORDER.  
> 
> Arnaldo, can we cap ehash_order and bhash_order at MAX_ORDER - 1?

There was a patch going arond for this already.
