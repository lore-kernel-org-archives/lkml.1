Return-Path: <linux-kernel-owner+w=401wt.eu-S1759753AbXEWUtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759753AbXEWUtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 16:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755148AbXEWUtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 16:49:43 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:51894 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388AbXEWUtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 16:49:43 -0400
Date: Wed, 23 May 2007 13:55:13 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Rene Herman <rene.herman@gmail.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, lkml <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] add "notime" boot option
Message-Id: <20070523135513.b3573f52.randy.dunlap@oracle.com>
In-Reply-To: <465492C8.9060003@gmail.com>
References: <20070522120938.db67f1e9.randy.dunlap@oracle.com>
	<46541F65.9060507@msgid.tls.msk.ru>
	<20070523100416.93835196.randy.dunlap@oracle.com>
	<465492C8.9060003@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007 21:15:20 +0200 Rene Herman wrote:

> On 05/23/2007 07:04 PM, Randy Dunlap wrote:
> 
> >> That's a good source of confusion.  To me, "notime" means something
> >> like "don't bother calculating time", instead of the proposed
> >> behavior.  Can't it be something like 'nologts' (no log timestamps)
> >> or nots or notimestamps or nologtime instead?
> > 
> > "nologtime" is OK with me.  or does it confuse people in a
> > different way?  Anyone else?
> 
> The CONFIG option is called CONFIG_PRINTK_TIME. How about "noprintktime"? At 
> least nicely to the point...

Actually I'm concerned about total kernel command line length,
so using option names that are "long" when short will do is not good IMO.

I.e., I can easily overflow a 255-byte command line length buffer,
so Shorter is Better.

However, "when short will do" does not mean making them unreadable or
like they mean something else, like "nopkt".

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
