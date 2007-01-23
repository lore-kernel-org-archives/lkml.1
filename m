Return-Path: <linux-kernel-owner+w=401wt.eu-S933086AbXAWG0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933086AbXAWG0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 01:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933088AbXAWG0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 01:26:19 -0500
Received: from xenotime.net ([66.160.160.81]:33720 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933086AbXAWG0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 01:26:18 -0500
Date: Mon, 22 Jan 2007 22:22:38 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Don Mullis <dwm@meer.net>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, rdunlap@xenotime.net
Subject: Re: `make htmldocs` fails
Message-Id: <20070122222238.b6628c6b.rdunlap@xenotime.net>
In-Reply-To: <m364aycmbt.fsf@meer.net>
References: <20070111222627.66bb75ab.akpm@osdl.org>
	<m364aycmbt.fsf@meer.net>
Organization: YPO4
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jan 2007 22:02:30 -0800 Don Mullis wrote:

> 
> Bisection shows the bad patch to be:
>     gregkh-driver-uio-documentation.patch
> 
> The htmldocs build failure can be eliminated by:
>     quilt remove Documentation/DocBook/kernel-api.tmpl

or by:  quilt delete gregkh-driver-uio-documentation.patch ??

> The error messages were:
> 
>     .../linux-2.6.19 $ make htmldocs
>       DOCPROC Documentation/DocBook/kernel-api.xml
>     Warning(/noback/kernel.org/2.6.20-rc_fault-injection/linux-2.6.19//drivers/uio/uio.c:521): No description found for parameter 'owner'
>     Warning(/noback/kernel.org/2.6.20-rc_fault-injection/linux-2.6.19//drivers/uio/uio.c:521): No description found for parameter 'info'
>     Warning(/noback/kernel.org/2.6.20-rc_fault-injection/linux-2.6.19//drivers/uio/uio.c:591): No description found for parameter 'idev'
>     Error(/noback/kernel.org/2.6.20-rc_fault-injection/linux-2.6.19//include/linux/uio_driver.h:33): cannot understand prototype: 'struct uio_info '
>     Warning(/noback/kernel.org/2.6.20-rc_fault-injection/linux-2.6.19//include/linux/uio_driver.h): no structured comments found
>     make[1]: *** [Documentation/DocBook/kernel-api.xml] Error 1
>     make: *** [htmldocs] Error 2
> 
> The failure was observed on an up-to-date Fedora Core 5 host. 

How about an accurate description of what kernel tree has this problem?
It's not 2.6.19.  It's not 2.6.20-rc5.

---
~Randy
