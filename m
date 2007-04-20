Return-Path: <linux-kernel-owner+w=401wt.eu-S2992642AbXDTIx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992642AbXDTIx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 04:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992695AbXDTIx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 04:53:28 -0400
Received: from gate.crashing.org ([63.228.1.57]:53033 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992642AbXDTIx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 04:53:27 -0400
Subject: Re: [PATCH] macintosh/mediabay: Convert to kthread API.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>
In-Reply-To: <20070419163001.a1928749.akpm@linux-foundation.org>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	 <11769695954018-git-send-email-ebiederm@xmission.com>
	 <20070419163001.a1928749.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 20 Apr 2007 18:51:58 +1000
Message-Id: <1177059118.6080.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Looks OK - there's no way of stopping the kernel thread anyway.
> 
> It appears that nobody has tried to use this driver at the same time as
> software-suspend.  At least, not successfully.  A strategic try_to_freeze()
> should fix it.
> 
> This will become (a little) more serious when cpu hotplug is switched to
> use the process freezer, and perhaps it breaks kprobes already.

I'll dig a box with that hardware and do some tests, but it looks nice.

Thanks Eric !

There should be no problem with cpu hotplug, the only machines using the
media bay driver are old Apple laptops with only one CPU and no HW
threads.

Ben.


