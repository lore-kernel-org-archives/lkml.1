Return-Path: <linux-kernel-owner+w=401wt.eu-S1767691AbXEDFsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767691AbXEDFsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 01:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767694AbXEDFr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 01:47:59 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59120 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767691AbXEDFru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 01:47:50 -0400
Date: Thu, 3 May 2007 22:47:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
       Christoph Lameter <clameter@sgi.com>, Lee.Schermerhorn@hp.com
Subject: Re: [PATCH] change global zonelist order v4 [0/2]
Message-Id: <20070503224730.3bc6f8a8.akpm@linux-foundation.org>
In-Reply-To: <20070427144530.ae42ee25.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070427144530.ae42ee25.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 14:45:30 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> Hi, this is version 4. including Lee Schermerhon's good rework.
> and automatic configuration at boot time.

hm, this adds rather a lot of code.  Have we established that it's worth
it?

And it's complex - how do poor users know what to do with this new control?


This:

+ *	= "[dD]efault | "0"	- default, automatic configuration.
+ *	= "[nN]ode"|"1" 	- order by node locality,
+ *         			  then zone within node.
+ *	= "[zZ]one"|"2" - order by zone, then by locality within zone

seems a bit excessive.  I think just the 0/1/2 plus documentation would
suffice?


I haven't followed this discussion very closely I'm afraid.  If we came up
with a good reason why Linux needs this feature then could someone please
(re)describe it?

Thanks.
